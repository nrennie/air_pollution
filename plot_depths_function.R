plot_depths_function <- function(depths, threshold, col_choice="black"){
  dates <- as.Date(as.numeric(names(depths)), origin="1970-01-01")
  df <- data.frame(dates, depths, dates)
  p <- ggplot(df, aes(x=dates, y=depths, group = 1)) + geom_point(size=2) + 
    geom_segment(aes(x=dates, xend=dates, y=0, yend=depths), color=col_choice) + 
    geom_hline(yintercept=threshold, col="red", size=1.5) + 
    ylab("Functional Depths") + ylim(0,1) +
    scale_x_date(name="") +
    theme_light() +
    theme(axis.text=element_text(size=14),axis.title=element_text(size=14),legend.text=element_text(size=14),plot.background = element_rect(fill = "transparent", color = NA),legend.background = element_rect(color = NA,fill="transparent"),legend.box.background = element_rect(fill = "transparent",color=NA),legend.position="none",legend.justification=c(0,1),legend.title=element_blank(),legend.key = element_blank())
  return(p) 
}

