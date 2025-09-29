#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { test_variants }   from './subworkflows/test_variants.nf'

tools_ch = Channel.of(params.tools.split(','))

workflow  {
    cohorts_ch = Channel.fromPath(params.cohorts)
        | splitCsv(header: true, sep: ',')
        | map { row -> [
            row.cohort,row.category,file(row.snps),file(row.traits),file(row.covariates)
        ] }

    tests = test_variants( cohorts_ch, tools_ch )
}
