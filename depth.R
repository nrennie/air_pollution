depth <- function(data, times=1:24, perc=0.01, B=1000, maxiter=50){
  n <- nrow(data)
  #array should be t (24) x n x p (1)
  d <- array(t(data), dim=c(ncol(data),nrow(data),1))
  depths <- mfd(d, time=times, type="projdepth")$MFDdepthZ
  names(depths) <- rownames(data)
  return(depths)
}
