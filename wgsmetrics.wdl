version 1.0

workflow wgsMetrics {
  input {
    File inputBam
    String? outputFileNamePrefix = ""
  }

  String? outputPrefix = if outputFileNamePrefix == "" then basename(inputBam, '.bam') else outputFileNamePrefix

  call collectWGSmetrics {
    input:
      inputBam = inputBam,
      outputPrefix = outputPrefix
  }

  call collectInsertSizeMetrics {
    input:
      inputBam = inputBam,
      outputPrefix = outputPrefix
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
    String? modules = "picard/2.19.2 hg19/p13"
  }

  parameter_meta {
    inputBam: "Input .bam file"
    refFasta: "Path to the reference fasta"
    metricTag: "matric tag is used as a file extension for output"
    filter: "Picard filter to use"
    outputPrefix: "Output prefix, either input file basename or custom string"
    jobMemory: "memory allocated for Job"
    coverageCap: "Coverage cap, picard parameter"
    modules: "Names and versions of modules for picard-tools, java and reference genome"
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
    String? modules = "picard/2.19.2"
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
