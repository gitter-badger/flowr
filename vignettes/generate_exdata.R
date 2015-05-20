## ---- echo = FALSE, message = FALSE--------------------------------------
knitr::opts_chunk$set(
  comment = "#>",
  error = FALSE,
  tidy = FALSE
)
library(flowr)
library(knitr)

## ------------------------------------------------------------------------
## create a vector of sample names
samp = sprintf("sample%s", 1:10)

tmp <- lapply(1:length(samp), function(i){
	## sleep for a few seconds (100 times)
	cmd_sleep = sprintf("sleep %s", abs(round(rnorm(10)*10, 0)))
	
	## Create 100 temporary files
	tmp10 = sprintf("tmp%s_%s", i, 1:10)
	cmd_tmp = sprintf("head -c 100000 /dev/urandom > %s", tmp10)
	
	## Merge them according to samples, 10 each
	cmd_merge <- sprintf("cat %s > merge%s", paste(tmp10, collapse = " "), i)

	## get the size of merged files
	cmd_size = sprintf("du -sh merge%s", i)
	
	cmd <- c(cmd_sleep, cmd_tmp, cmd_merge, cmd_size)
	jobname <- c(rep("sleep", length(cmd_sleep)),
		rep("tmp", length(cmd_tmp)),
		rep("merge", length(cmd_merge)),
		rep("size", length(cmd_size)))
	## create a DF
	df = data.frame(samplename = samp[i],
		jobname = jobname, 
		cmd = cmd)
})

flow_mat = do.call(rbind, tmp)
kable(head(flow_mat))

## ------------------------------------------------------------------------
def = sample_flow_def(jobnames = unique(flow_mat$jobname))
kable(def)

## ------------------------------------------------------------------------
def[def[, 'jobname'] == "merge","dep_type"] = "gather"
def[def[, 'jobname'] == "merge","sub_type"] = "serial"
def[def[, 'jobname'] == "size","sub_type"] = "serial"
kable(def)

## ----eval=FALSE----------------------------------------------------------
#  write.table(flow_mat, file = "inst/extdata/example1_flow_mat.txt",
#  	row.names = FALSE, quote = FALSE, sep = "\t")
#  write.table(def, file = "inst/extdata/example1_flow_def.txt",
#  	row.names = FALSE, quote = FALSE, sep = "\t")
