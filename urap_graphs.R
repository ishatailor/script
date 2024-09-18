library(dplyr)
library(ggplot2)

# Read the data
df <- read.csv('/Users/Isha/PycharmProjects/pythonProject/updated_urap_data.csv')

# Clean and summarize the data for the first plot
df_clean <- df %>%
  filter(!is.na(Cited.by.Count) & !is.na(Year) & !is.na(Journal))

# Check column names
print(names(df_clean))

df_summary <- df_clean %>%
  group_by(Journal, Year) %>%
  summarise(Average.Cited.by.Count = mean(Cited.by.Count, na.rm = TRUE), .groups = "drop")

# Check df_summary content
print(head(df_summary))

# Plot the average Cited by Count over the years by journal
plot1 <- ggplot(df_summary, aes(x = Year, y = Average.Cited.by.Count, color = Journal)) +
  geom_line() +
  labs(title = "Average Cited by Count Over the Years by Journal",
       x = "Publication Year",
       y = "Average Cited by Count") +
  theme_minimal()

print(plot1)

# Clean and summarize the data for the second plot
df_clean <- df %>%
  filter(!is.na(Cited.by.Count) & !is.na(Year) & !is.na(Journal) & !is.na(Mixed.methods))

# Check column names
print(names(df_clean))

df_summary_mixed <- df_clean %>%
  group_by(Journal, Year, Mixed.methods) %>%
  summarise(Average.Cited.by.Count = mean(Cited.by.Count, na.rm = TRUE), .groups = "drop")

# Check df_summary_mixed content
print(head(df_summary_mixed))

# Plot the average Cited by Count over the years, stratified by mixed-methods, for each journal
plot2 <- ggplot(df_summary_mixed, aes(x = Year, y = Average.Cited.by.Count, color = Mixed.methods, linetype = Mixed.methods)) +
  geom_line() +
  facet_wrap(~ Journal) +
  labs(title = "Average Cited by Count Over the Years by Journal and Mixed-Methods",
       x = "Publication Year",
       y = "Average Cited by Count") +
  theme_minimal()

print(plot2)

