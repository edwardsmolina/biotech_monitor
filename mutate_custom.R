# plot_dat <- tibble(x = c("A", "B"),
#          y = c(2, 5),
#          col = c("red", "blue"))
# cols <- rlang::set_names(plot_dat$col, plot_dat$x)
# ggplot(plot_dat, aes(x,y)) + geom_col(aes(fill = x)) +
#   scale_fill_manual(values = cols)
# 
df <- tibble::tribble(
  ~FIELD_name, ~commercialName,    ~Means,
  "SRUIZ_NUEVAESPERANZA_BOIX_F22", "DK7220VTPRO4", "1",
  "SRUIZ_NUEVAESPERANZA_BOIX_F22", "DK7612VT3P", "51.02",
  "CSALO9_FRENTONES_MONTORO_F22", "AY8111ABA1", "48.71",
  "CARDILLO_FRENTONES_MONTORO_F22", "NEXT226PWU", "39.59",
  "CARDILLO_FRENTONES_MONTORO_F22", "NEXT226XXX", "39.59",
  "CARDILLO_FRENTONES_MONTORO_F22", " DK72-10 RR2", "50",
  "CARDILLO_FRENTONES_MONTORO_F22", "NEXT 25.8 PWU", "50"
)

brand_assign <- function(data, geno, brand, col) {
  # geno <- enquo(geno)
  mutate(data,
         !!brand := case_when(
           str_detect({{geno}}, "DK") ~ "DK",
           str_detect({{geno}}, "LT") ~ "LT",
           str_detect({{geno}}, "MQK1|AY") ~ "PS4",
           TRUE ~ "Compet."), 
         !!col := case_when(
           brand == "Compet." ~ "grey70", 
           brand == "DK" ~ "orange", 
           brand == "LT" ~ "#009E73", 
           brand == "PS4" ~ "steelblue"))
}

# df %>% brand_assign(geno=commercialName, "brand", "col") 
  
event_separate <- function(data, geno_in, biotech, geno_out) {
  mutate(data,
         !!biotech := case_when(
           str_detect({{geno_in}}, 'ABA1') ~'ABA1',
           str_detect({{geno_in}}, 'VT3P') ~'VT3P',
           str_detect({{geno_in}}, 'TRE') ~'TRE',
           str_detect({{geno_in}}, 'FHJ1') ~'FHJ1',
           str_detect({{geno_in}}, 'FHJ2') ~'FHJ2',
           str_detect({{geno_in}}, 'MQK1') ~ 'MQK1',
           str_detect({{geno_in}}, 'MQK2') ~ 'MQK2',
           # str_detect({{geno}}, 'PWU') ~ 'PWU',
           # str_detect({{geno}}, '-8PWU') ~ '-8PWU',
           str_detect({{geno_in}}, 'PRO2') ~ 'PRO2',
           str_detect({{geno_in}}, 'PRO3|VT3P|MQK1') ~ 'VT3P',
           str_detect({{geno_in}}, 'PRO4') ~ 'PRO4',
           str_detect({{geno_in}}, 'VTPRO4') ~ 'VTPRO4',
           # str_detect({{geno}}, 'PRO4') ~ 'PRO4',
           # str_detect({{geno}}, 'VYHR') ~ 'VYHR',
           # str_detect({{geno}}, 'VIP3CL') ~ 'VIP3CL',
           # str_detect({{geno}}, 'VIP3|VIPTERA3') ~ 'VIP3',
           str_detect({{geno_in}}, 'RR') ~ 'RR2',
           str_detect({{geno_in}}, 'FS500') ~ 'CONV', 
           str_detect({{geno_in}}, 'FS500') ~ 'CONV', 
           TRUE ~ "other"),
         geno_inter1 := str_remove({{geno_in}}, fixed(biotech)),
         geno_inter2 :=   case_when(
           str_detect(geno_inter1, "NEXT226") ~"NEXT226", 
           TRUE ~ geno_inter1),
         !!geno_out := str_replace_all( 
           str_replace_all(str_remove(geno_inter2, "VT"), "[[:punct:]]", ""), 
           regex("\\s*"), "")) 
  
}

# df %>% 
#   event_separate(geno_in=commercialName, "biotech", "plain_name")   
  
# ctrl_eff <- function(data, geno_name, var, geno_ref) {
#   mutate(data,
#          drop_na({{var}}) %>% 
#            group_by({{geno_name}}) %>% 
#            summarise(var=mean({{var}}, na.rm=TRUE)) %>%
#            ungroup() %>% 
#            mutate(
#              ref={{var}}[{{geno_name}}=={{geno_ref}}],
#              CE = (1-({{var}}/ref))*100))
# }
# 
# df %>% 
#   event_separate(geno_in=commercialName, "biotech", "plain_name") %>% 
#   ctrl_eff(geno_name=plain_name, Means, geno_ref="DK7210")           


get_mdr <- function(data, FIELD_name, mdr) {
  mutate(data, !!mdr := str_extract({{FIELD_name}}, "[^_]+")) 
  
}

# df %>% get_mdr(FIELD_name, "mdr")


         
         
