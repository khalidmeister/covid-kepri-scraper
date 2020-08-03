import pandas as pd
import requests
import re
import csv
from datetime import date
from bs4 import BeautifulSoup

r = requests.get('https://corona.kepriprov.go.id/data.phtml')
soup = BeautifulSoup(r.content, 'html.parser')

# Scrape data dan simpan di csv
with open('kepri.csv', 'a+') as csv_file:
    fieldnames = ['tanggal', 'wilayah', 'total_positif', 'aktif', 'sembuh', 'meninggal']
    writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
    list_wilayah = soup.find_all('div', {'class':'box-alkes'})[11:18]
    # Cukup Sekali saja => writer.writeheader()
    for wilayah in list_wilayah:
        nama = wilayah.find_all('span')[0].text
        nama = nama.strip()
        nama = re.sub(r'(Kab.|Kota)\s', '', nama)
        temp = {}
        temp['tanggal'] = date.today()
        temp['wilayah'] = nama
        c = 2
        for data in wilayah.find_all('span', {'class':'timer'}):
            temp[fieldnames[c]] = data['data-to']
            c += 1
        writer.writerow(temp)

# Print Hasil (Untuk Temporary)
df = pd.read_csv('kepri.csv')
print("-" * 50)
print("Rekapitulasi COVID-19 di Kepulauan Riau")
print("Per tanggal", date.today(), "Sumber: corona.keprigov.go.id")
print("-" * 50)
list_wilayah = soup.find_all('div', {'class':'box-alkes'})[11:18]
for wilayah in list_wilayah:
    nama = wilayah.find_all('span')[0].text
    nama = nama.strip()
    nama = re.sub(r'(Kab.|Kota)\s', '', nama)
    print(nama, end=" ")
    for data in wilayah.find_all('span', {'class':'timer'}):
        print(data['data-to'], end=" ")
    print()
print("-" * 50)
print("Total:", df['total_positif'].sum())
print("-" * 50)

