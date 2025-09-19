# Week 4
In this assignment we will learn how to access genomic data starting by a reference genome 
## Identifing accession number & Downloading
Since the long term purpose of this is to reproduce the paper. I will start by checking the exact same reference that they used: 
<img width="1848" height="1170" alt="image" src="https://github.com/user-attachments/assets/c0c9bc9a-6969-42ce-92a1-f489ab5d254d" />
With the accession number in mind I'll use the following command: 


    efetch -db nuccore -format fasta -id NC_007793.1 > NC_007793.1.fa

Since this is not a reference genome, I decided to check the reference genome of this specie by checking in NCBI database: 
<img width="1848" height="1170" alt="image" src="https://github.com/user-attachments/assets/49ed314c-aba6-4cd6-a432-cb8dcf4cfb92" />

And also check the info of that genome

    datasets summary genome accession GCA_000013425.1 | jq
that outputs 

    {
      "reports": [
        {
          "accession": "GCA_000013425.1",
          "annotation_info": {
            "name": "Annotation submitted by University of Oklahoma Health Sciences Center",
            "provider": "University of Oklahoma Health Sciences Center",
            "release_date": "2014-01-31",
            "stats": {
              "gene_counts": {
                "non_coding": 75,
                "protein_coding": 2892,
                "pseudogene": 2,
                "total": 2969
              }
            }
          },
          "assembly_info": {
            "assembly_level": "Complete Genome",
            "assembly_name": "ASM1342v1",
            "assembly_status": "current",
            "assembly_type": "haploid",
            "bioproject_accession": "PRJNA237",
            "bioproject_lineage": [
              {
                "bioprojects": [
                  {
                    "accession": "PRJNA237",
                    "title": "Typical laboratory strain"
                  }
                ]
              }
            ],
            "biosample": {
              "accession": "SAMN02604235",
              "attributes": [
                {
                  "name": "strain",
                  "value": "NCTC 8325"
                },
                {
                  "name": "sub_species",
                  "value": "aureus"
                }
              ],
              "bioprojects": [
                {
                  "accession": "PRJNA237"
                }
              ],
              "description": {
                "organism": {
                  "organism_name": "Staphylococcus aureus subsp. aureus NCTC 8325",
                  "tax_id": 93061
                },
                "title": "Sample from Staphylococcus aureus subsp. aureus NCTC 8325"
              },
              "last_updated": "2015-05-18T13:21:01.110",
              "models": [
                "Generic"
              ],
              "owner": {
                "name": "NCBI"
              },
              "package": "Generic.1.0",
              "publication_date": "2014-01-30T15:13:19.920",
              "sample_ids": [
                {
                  "label": "Sample name",
                  "value": "CP000253"
                }
              ],
              "status": {
                "status": "live",
                "when": "2014-01-30T15:13:19.920"
              },
              "strain": "NCTC 8325",
              "sub_species": "aureus",
              "submission_date": "2014-01-30T15:13:19.920"
            },
            "paired_assembly": {
              "accession": "GCF_000013425.1",
              "annotation_name": "Annotation submitted by NCBI RefSeq",
              "status": "current"
            },
            "refseq_category": "reference genome",
            "release_date": "2006-02-13",
            "submitter": "University of Oklahoma Health Sciences Center"
          },
          "assembly_stats": {
            "atgc_count": "2821360",
            "contig_l50": 1,
            "contig_n50": 2821361,
            "gc_count": "927332",
            "gc_percent": 33,
            "number_of_component_sequences": 1,
            "number_of_contigs": 1,
            "number_of_scaffolds": 1,
            "scaffold_l50": 1,
            "scaffold_n50": 2821361,
            "total_number_of_chromosomes": 1,
            "total_sequence_length": "2821361",
            "total_ungapped_length": "2821361"
          },
          "average_nucleotide_identity": {
            "best_ani_match": {
              "ani": 99.94,
              "assembly": "GCA_006094915.1",
              "assembly_coverage": 96.32,
              "category": "type",
              "organism_name": "Staphylococcus aureus",
              "type_assembly_coverage": 97.66
            },
            "category": "category_na",
            "comment": "na",
            "match_status": "species_match",
            "submitted_ani_match": {
              "assembly": "no-type",
              "category": "no_type",
              "organism_name": "na"
            },
            "submitted_organism": "Staphylococcus aureus subsp. aureus NCTC 8325",
            "submitted_species": "Staphylococcus aureus",
            "taxonomy_check_status": "OK"
          },
          "checkm_info": {
            "checkm_marker_set": "Staphylococcus aureus",
            "checkm_marker_set_rank": "species",
            "checkm_species_tax_id": 1280,
            "checkm_version": "v1.2.4",
            "completeness": 97.59,
            "completeness_percentile": 14.4983,
            "contamination": 0.39
          },
          "current_accession": "GCA_000013425.1",
          "organism": {
            "infraspecific_names": {
              "strain": "NCTC 8325"
            },
            "organism_name": "Staphylococcus aureus subsp. aureus NCTC 8325",
            "tax_id": 93061
          },
          "paired_accession": "GCF_000013425.1",
          "source_database": "SOURCE_DATABASE_GENBANK"
        }
      ],
      "total_count": 1
    }

Now let's download: 


      datasets download genome accession GCA_000013425.1 
And it's annotations 


    datasets download genome accession GCA_000013425.1 --include gff3,rna,cds,protein,genome,seq-report

## Visualizing 

Now use IGV to visualize the genome and the annotations relative to the genome.
<img width="1854" height="1175" alt="image" src="https://github.com/user-attachments/assets/af6e23ef-2dcb-43c1-b0cf-5d401ba8d85e" />

## Genome features 
### Genome size 
```
cat *gff | cut -f 1 | sort | uniq

```
The output is 

    #!genome-build ASM1342v1
    #!genome-build-accession NCBI_Assembly:GCA_000013425.1
    #!gff-spec-version 1.21
    #!processor NCBI annotwriter
    ###
    ##gff-version 3
    ##sequence-region CP000253.1 1 2821361
    ##species https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=93061
    CP000253.1

The genome size of *S. aureus* is 2'821,361 pb 
### Features 
```
cat *gff | grep -v "#" | cut -f 3 |  sort | uniq -c 
   2892 CDS
     77 exon
   2967 gene
      2 pseudogene
      2 pseudogenic_tRNA
     16 rRNA
      1 region
     59 tRNA
```
### Longest gene 

What is the longest gene? What is its name and function? You may need to search other resources to answer this question. Look at other gene names. Pick another gene and describe its name and function. TODO

### Genomic features visualization
Look at the genomic features, are these closely packed, is there a lot of intragenomic space? Using IGV estimate how much of the genome is covered by coding sequences.
<img width="1859" height="402" alt="image" src="https://github.com/user-attachments/assets/23cd1f49-73f5-4b6f-9cec-f4a23e300500" />
Not really, the intragenomic space is very small which makes sense for a bacterial genome. 

## Alternative genome builds that can be used 
The paper has the goal to characterize gene alterations to identify the underlying mechanisms of the bacteriostatic effect of propionate on MRSA using a transcriptomic approach. In the context of bacterial resistance something that can be explored is trying to have prevalence of the variants associated with antimicrobial resistance using multiple genome assemblies from a region or even worldwide.
For this purpose I search for *S. aureus* genomes at NCBI genomes finding 116,772. 
<img width="1852" height="1120" alt="image" src="https://github.com/user-attachments/assets/c3b3c063-0e52-4cb1-b611-36eb7ffed315" />

Other question that might be asked changing the genome build are:
- Using genome builds from different S. aureus strains (like Newman, N315, Mu50, or MW2) could reveal whether propionate's metabolic effects are conserved across lineages or if certain strains have unique resistance mechanisms
- Accessory gene impacts: Different genome builds would capture strain-specific genes that might influence propionate susceptibility, particularly mobile genetic elements and strain-specific metabolic genes
- Comparing transcriptomes against HA-MRSA genome builds (like N315 or Mu50) versus CA-MRSA builds could reveal different metabolic vulnerabilities
- Vancomycin-resistant strains: Using VRSA genome builds could reveal if propionate effectiveness changes in strains with existing antibiotic resistance mechanisms
- Methicillin-susceptible S. aureus (MSSA): Comparing against MSSA genome builds could isolate the specific impact of methicillin resistance genes on propionate response
- Metabolic pathway completeness: Different strains may have variations in the purine, riboflavin, and glycine/serine/threonine pathways identified in this study - using their genome builds could reveal which pathway components are essential versus dispensable
- Regulatory network differences: Strain-specific transcriptional regulators could show different propionate-responsive gene networks
- Personalized treatment prediction: Using genome builds from clinical isolates could help predict which patient strains might be most susceptible to propionate therapy
- Co-infection dynamics: Using genome builds from other pathogens could explore propionate's effects in polymicrobial infections
