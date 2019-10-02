version 1.0

workflow wgsMetrics {
input {
    File    inputBam
    String? refFasta = "$HG19_ROOT/hg19_random.fa"
    String? outputFileNamePrefix = ""
    String? stringencyFilter = "LENIENT"
    String? modules = "java/8 picard/2.19.2 hg19/p13"
    Int?    coverageCap = 500
}

call collectWGSmetrics{ input: inputBam = inputBam, refFasta = refFasta, filter = stringencyFilter, coverageCap = coverageCap, outputPrefix = outputFileNamePrefix, modules = modules }

output {
  File outputWGSMetrics  = collectWGSmetrics.outputWGSMetrics
}

}

# ==========================================
#  TASK 1 of 1: collect WGS metric
# ==========================================
task collectWGSmetrics {
input { 
        File   inputBam
        String? refFasta
        String? metricTag  = "WGS"
        String? filter     = "LENIENT"
        String? outputPrefix = ""
        Int?   jobMemory   = 18
        Int?   javaMemory  = 12
        Int?   coverageCap = 500
        String? modules    = ""
}

command <<<
 java -Xmx~{javaMemory}G -jar $PICARD_ROOT/picard.jar CollectWgsMetrics \
                              TMP_DIR=picardTmp \
                              R=~{refFasta} \
                              COVERAGE_CAP=~{coverageCap} \
                              INPUT=~{inputBam} \
                              OUTPUT="~{outputPrefix}.~{metricTag}" \
                              VALIDATION_STRINGENCY=~{filter} 
>>>

runtime {
  memory:  "~{jobMemory} GB"
  modules: "~{modules}"
}

output {
  File outputWGSMetrics = "~{outputPrefix}.~{metricTag}"
}
}

