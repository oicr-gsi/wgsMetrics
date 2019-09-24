version 1.0

workflow wgsMetrics {
input {
    File    inputBam
    File    baitBed
    File    targetBed
    String  refFasta
    String? outputPrefix = ""
    String? stringencyFilter = "LENIENT"
    Int?    coverageCap = 500
}

call collectWGSmetrics{ input: inputBam = inputBam, refFasta = refFasta, filter = stringencyFilter, coverageCap = coverageCap, outputPrefix = outputPrefix }

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
        String refFasta
        String? metricTag  = "WGS"
        String? filter     = "LENIENT"
        String? outputPrefix = ""
        Int?   jobMemory   = 20
        Int?   javaMemory  = 14
        Int?   coverageCap = 500
        String? modules    = "java/8 picard/2.19.2 hg19/p13"
}

command <<<
 java -Xmx~{javaMemory}G -jar $PICARD_ROOT/picard.jar CollectWgsMetrics \
                              TMP_DIR=picardTmp \
                              R=~{refFasta} \
                              COVERAGE_CAP=~{coverageCap} \
                              INPUT=~{inputBam} \
                              OUTPUT="~{basename(inputBam, '.bam')}~{outputPrefix}.~{metricTag}" \
                              VALIDATION_STRINGENCY=~{filter} 
>>>

runtime {
  memory:  "~{jobMemory} GB"
  modules: "~{modules}"
}

output {
  File outputWGSMetrics = "~{basename(inputBam, '.bam')}~{outputPrefix}.~{metricTag}"
}
}

