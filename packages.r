install.packages("sf",dependencies = T)
install.packages("terra",dependencies = T)
install.packages("torch",dependencies = T)
install.packages("luz",dependencies = T)
torch::install_torch()
install.packages("sits", dependencies = TRUE)
install.packages("sitsdata", dependencies = TRUE)
install.packages("devtools", dependencies = T)
devtools::install_github("e-sensing/sits@dev", dependencies = TRUE)
options(download.file.method = "wget")
devtools::install_github("e-sensing/sitsdata")
