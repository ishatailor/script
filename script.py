import requests
import pandas as pd
import time


def search_crossref(query):
    search_url = 'https://api.crossref.org/works'
    params = {
        'query': query,
        'rows': 1,  # Fetch one result
        'filter': 'type:journal-article'
    }
    try:
        print(f"Querying CrossRef for: {query}")  # Log the query being sent
        response = requests.get(search_url, params=params)
        if response.status_code == 200:
            data = response.json()
            items = data.get('message', {}).get('items', [])
            if items:
                item = items[0]
                href_link = item.get('URL', 'N/A')
                cited_by_count = item.get('is-referenced-by-count', 'N/A')
                article_id = item.get('DOI', 'N/A')
                return href_link, cited_by_count, article_id
            else:
                print(f"No results found for query: {query}")
        else:
            print(f"Request failed with status code {response.status_code}")
    except Exception as e:
        print(f"Error during request: {e}")
    return 'N/A', 'N/A', 'N/A'


def scrape_data(df):
    href_links = []
    cited_by_counts = []
    article_ids = []

    for title in df['Title']:
        print(f"Searching for: {title}")
        href_link, cited_by_count, article_id = search_crossref(title)
        href_links.append(href_link)
        cited_by_counts.append(cited_by_count)
        article_ids.append(article_id)
        time.sleep(2)  # Respectful delay between requests

    df['HREF Link'] = href_links
    df['Cited by Count'] = cited_by_counts
    df['Article ID'] = article_ids
    return df


# Load dataset
try:
    df = pd.read_csv('urap_data.csv')
    print("CSV file loaded successfully.")
except FileNotFoundError:
    print("The CSV file 'urap_data.csv' was not found.")
    raise

# Scrape data
df = scrape_data(df)

# Save updated dataset
try:
    df.to_csv('updated_urap_data.csv', index=False)
    print("Data saved successfully.")
except Exception as e:
    print(f"An error occurred while saving the file: {e}")
