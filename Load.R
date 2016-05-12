# Carico librerie
library(dplyr)

# Leggo i file (devono essere presenti in locale nella cartella /Data)
projects <- read.csv2('Data/cordis-h2020projects.csv', stringsAsFactors = F)
organisations <- read.csv2('Data/cordis-h2020organizations.csv', stringsAsFactors = F)
programmes <- read.csv2('Data/cordisref-H2020programmes.csv', stringsAsFactors = F)
topics <- read.csv2('Data/cordisref-H2020topics.csv', stringsAsFactors = F, sep = ',')


# Sistemo nome colonna id in projects
## C'è un modo migliore??
colnames(projects) <- c('rcn', c(colnames(projects)[2:length(colnames(projects))]))

# Nodi
# Nodi progetti
projNodes <- projects %>%
    select(id = rcn) %>%
    mutate(type = 'project', level = 2) %>%
    mutate(id = as.character(id)) %>%
    unique()

# Nodi organizazioni
orgNodes <- organisations %>%
    select(id) %>%
    mutate(type = 'organisation', level = 1) %>%
    mutate(id = as.character(id)) %>%
    unique()

# Nodi Topi
topNodes <- topics %>%
    select(id = topicCode) %>%
    mutate(type = 'topic', level = 3) %>%
    mutate(id = as.character(id)) %>%
    unique()

# Unione nodi
# nodes <- bind_rows(projNodes, orgNodes) %>%
    # bind_rows(topNodes)
nodes <- bind_rows(projNodes, topNodes)


# Edges
# Edges da organization a project
edgeOrgProj <- organisations %>%
    select(from = id, to = projectRcn) %>%
    mutate(to = as.character(to))

# Edges da project a topic
edgeProjTopic <- projects %>%
    select(from = rcn, to = topics)

# Unione edges
edges <- bind_rows(edgeProjTopic, edgeOrgProj)

