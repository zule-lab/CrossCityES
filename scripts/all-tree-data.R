all_tree_data <- c(
  
  tar_target(
    all_tree_raw,
    rbind(cal_tree, hal_tree, mon_tree, ott_tree, tor_tree, van_tree, win_tree)
  ),
  
  tar_target(
    all_tree_e,
    all_tree_raw %>%
      drop_na(city) %>%
      mutate(species = as.factor(species),
             genus = as.factor(genus),
             city = as.factor(city),
             fullname = as.factor(paste0(genus, " ", species))) %>%
      group_by(city) %>%
      mutate(nspecies = n_distinct(fullname))
  ), 
  
  tar_target(
    all_tree,
    assign_sp_all(all_tree_e)
  ),
  
  tar_target(
    sp_count_city,
    all_tree %>% 
      group_by(city) %>% 
      summarise(nspecies = n_distinct(fullname)) %>%
      ggplot(aes(x = city, y = nspecies)) + 
      geom_col() + 
      theme_classic() +
      labs(x = "", y = "Species Count") + 
      geom_text(aes(label = nspecies), vjust = -0.1)
  ),
  
  tar_target(
    tree_count_city,
    all_tree %>% 
      group_by(city) %>% 
      ggplot(aes(x = city)) +
      geom_bar()+
      theme_classic() + 
      labs(x = "", y = "Tree Count") + 
      geom_text(stat='count', aes(label=..count..), vjust=-0.1)
  ),
  
  tar_target(
    abundance,
    all_tree %>%
      group_by(city, fullname) %>%
      summarise(n = n()) %>%
      mutate(freq = (n / sum(n))*100) %>%
      arrange(desc(freq), .by_group = T)
  ),
  
  tar_target(
    oneper_city,
    abundance %>%
      filter(freq > 0.99) %>%
      group_by(city) %>%
      summarize(s = sum(freq))
  ),
  
  tar_target(
    oneper_hood,
    all_tree %>%
      group_by(city, hood, fullname) %>% 
      summarise(n = n()) %>%
      mutate(freq_hood = (n / sum(n))*100) %>%
      filter(freq_hood > 1) %>%
      mutate(nspecies = n_distinct(fullname)) %>%
      ungroup() %>%
      group_by(city, hood) %>% 
      mutate(s = sum(freq_hood))
  ),
  
  tar_target(
    sp_list,
    as_tibble(unique(oneper_hood$fullname)) %>% 
      rename(Species = value) %>% 
      arrange(Species)
  )
)