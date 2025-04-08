# inspired by janitor::tabyl(),
# to skip the dependency

tabyl <- function(x) {
  dataframe <- tibble::tibble(x = x) %>%
    dplyr::count(x) %>%
    dplyr::mutate(percent = n / sum(n))
  colnames(dataframe) <- c(".", "n", "percent")
  dataframe
}
