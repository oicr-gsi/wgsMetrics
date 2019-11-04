version 1.0

workflow wgsMetrics {
  input {
    File inputBam
    String? outputFileNamePrefix = basename(inputBam, '.bam')
  }

  call collectWGSmetrics {
    input:
      inputBam = inputBam,
      outputPrefix = outputFileNamePrefix
  }

  call collectInsertSizeMetrics {
    input:
      inputBam = inputBam,
      outputPrefix = outputFileNamePrefix
  }

  output {
    File outputWGSMetrics  = collectWGSmetrics.outputWGSMetrics
    File insertSizeMetrics = collectInsertSizeMetrics.insertSizeMetrics
    File histogramReport = collectInsertSizeMetrics.histogramReport
  }

  meta {
    author: "Peter Ruzanov"
    email: "peter.ruzanov@oicr.on.ca"
    description: "WGSMetrics 1.0"
  }
}

# ==========================================
#  TASK 1 of 1: collect WGS metric
# ==========================================
task collectWGSmetrics {
  input {
    File inputBam
    String? picardJar = "$PICARD_ROOT/picard.jar"
    String? refFasta = "$HG19_ROOT/hg19_random.fa"
    String? metricTag = "HS"
    String? filter = "LENIENT"
    String? outputPrefix = "OUTPUT"
    Int? jobMemory = 18
    Int? coverageCap = 500
    String? modules = "picard/2.21.2 hg19/p13"
  }

  parameter_meta {
    picardJar: "Picard jar file to use"
    inputBam: "Input file (bam or sam)"
    refFasta: "Path to the reference fasta"
    metricTag: "metric tag is used as a file extension for output"
    filter: "Picard filter to use"
    outputPrefix: "Output prefix, either input file basename or custom string"
    jobMemory: "memory allocated for Job"
    coverageCap: "Coverage cap, picard parameter"
    modules: "Environment module names and version to load (space separated) before command execution"
  }

  meta {
    output_meta : {
      outputWGSMetrics: "Metrics about the fractions of reads that pass base and mapping-quality filters as well as coverage (read-depth) levels (see https://broadinstitute.github.io/picard/picard-metric-definitions.html#CollectWgsMetrics.WgsMetrics)"
    }
  }

  command <<<
    java -Xmx~{jobMemory-6}G -jar ~{picardJar} \
    CollectWgsMetrics \
    TMP_DIR=picardTmp \
    R=~{refFasta} \
    COVERAGE_CAP=~{coverageCap} \
    INPUT=~{inputBam} \
    OUTPUT="~{outputPrefix}.~{metricTag}.txt" \
    VALIDATION_STRINGENCY=~{filter}
  >>>

  runtime {
    memory:  "~{jobMemory} GB"
    modules: "~{modules}"
  }

  output {
    File outputWGSMetrics = "~{outputPrefix}.~{metricTag}.txt"
  }
}

task collectInsertSizeMetrics {
  input {
    File inputBam
    String? picardJar = "$PICARD_ROOT/picard.jar"
    Float? minimumPercent = 0.5
    String? outputPrefix = "OUTPUT"
    Int? jobMemory = 18
    String? modules = "picard/2.21.2 rstats/3.6"
  }

  parameter_meta {
    picardJar: "The picard jar to use"
    inputBam: "Input file (bam or sam)"
    minimumPercent: "Discard any data categories (out of FR, TANDEM, RF) when generating the histogram (Range: 0 to 1)"
    outputPrefix: "Output prefix to prefix output file names with"
    jobMemory: "Memory (in GB) allocated for job"
    modules: "Environment module names and version to load (space separated) before command execution"
  }

  meta {
    output_meta : {
      insertSizeMetrics: "Metrics about the insert size distribution (see https://broadinstitute.github.io/picard/picard-metric-definitions.html#InsertSizeMetrics)",
      histogramReport: "Insert size distribution plot"
    }
  }

  command <<<
    java -Xmx~{jobMemory-6}G -jar ~{picardJar} \
    CollectInsertSizeMetrics \
    TMP_DIR=picardTmp \
    INPUT=~{inputBam} \
    OUTPUT="~{outputPrefix}.isize.txt" \
    HISTOGRAM_FILE="~{outputPrefix}.histogram.pdf" \
    MINIMUM_PCT=~{minimumPercent}
  >>>

  runtime {
    memory: "~{jobMemory} GB"
    modules: "~{modules}"
  }

  output {
    File insertSizeMetrics = "~{outputPrefix}.isize.txt"
    File histogramReport = "~{outputPrefix}.histogram.pdf"
  }
}
