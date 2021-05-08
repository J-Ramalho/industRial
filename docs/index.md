--- 
title: "indust<b style='color:#38598CFF'>R</b>ial data science"
subtitle: Case studies in product development and manufacturing
author: "João Ramalho"
date: "2021-05-08"
# output: pdf_document
site: bookdown::bookdown_site
output: 
  bookdown::gitbook:
    includes:
      in_header: includeme.html
    css: industRialds.css
    fontsettings:
      theme: white
      family: sans
      size: 1
# documentclass: book
bibliography:
- book.bib
- packages.bib
biblio-style: apalike
link-citations: yes
editor_options:
  chunk_output_type: console
nocite: |
  @Broc2016, @Cano2012, @Cano2015, @Munro2015, @Scrucca2004, @Bass2007
description: ''
github-repo: "J-Ramalho/industRialds"
cover-image: "img/cover3.png"
---



# (PART) INTRODUCTION {-}

# Welcome {-}

<a href="">
  <img src="img/cover3.png" width="250" style="margin: 0 1em 0 1em" align="right"/>
</a> 

This book provides examples on how to use Data Science tools and techniques in Product Development and Manufacturing. These examples are grouped in Case Studies in a "cookbook" approach, making it easier to directly adopt the tools. They come from varied manufacturing industries, mostly where repetitive production in massive quantities is involved, such as:

+ pharmaceuticals
+ food
+ electronics
+ watch making
+ automotive

Product Development and Manufacturing are very important activities in society because bringing innovative products to the market has an immense potential to improve the quality of life of everyone. 

Additionally Data Science brings new powerful approaches to the engineering and manufacturing of consumer goods, helping minimising environmental impact, improving quality and keeping costs under control.

**How to use this book**

In this book it is assumed that the reader is already familiar with the product development and manufacturing quality methodologies such as dmaic and six sigma and the associated statistical concepts. Furthermore it is considered that he brings at least a beginner knowledge on R. The book focus is then on putting the different areas together.

Being a collection of case studies, the book is better used as a reference book. To get to the desired section go to the contents session which includes a full list of Case Studies, Datasets and R functions. 

Additionally we refer to several good quality books on both Data Science and  Product Development that have served to provide the required theoretical  background. These cover key disciplines such as six sigma, statistics and computer programming. This book aims complementing them and showcase how to benefit from recent software in this area.

**Acknowledgements**

I would like to express my gratitude to the instructors and colleagues who have spent time sharing their knowledge, answering my questions and giving me inputs: Enrico Chavez, Iegor Rudnytskyi, Giulia Ruggeri, Harry Handerson and Bobby Stuijfzand from the EPFL ADSCV team; Jean-Vincent Le Bé, Jasmine Petry, Yvan Bouza, James Clulow and Akos Spiegel from the Nestlé STC team; Frank Paris from DOQS; Théophile Emmanouilidis and Sélim Ach from Thoth.

To report any issue or make suggestions please open an issue on the book repository:
[industRialds/issues](https://github.com/J-Ramalho/industRialds/issues)

**About the authors**

<b style="color:#104e8b">João Ramalho</b> is a Senior Industrial Data Scientist with more than 20 years of experience in the manufacturing industry. He's been in varied positions in R&D, Operations and IT at Philip Morris, Rolex and Nestlé. He holds a Master in Mechanical Engineering from the IST of Lisbon, a PMP certification from the Project Management Institute and a Data Science certification from DataCamp. He's currently specializing in Data Visualization at the Swiss technical university EPFL. See full profile at [j-ramalho.github.io](https://j-ramalho.github.io/)