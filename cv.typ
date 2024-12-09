#import "@preview/fontawesome:0.5.0": fa-icon
#import "@preview/cades:0.3.0": qr-code

#set page(paper: "a4", margin: 1cm)

#let title(body) = [
  #set text(size: 12pt, font: "Helvetica Neue")
  = #body
  #line(length: 100%, stroke: (thickness: 1pt, dash: "loosely-dotted"))
]

#set text(size: 12pt, font: "Helvetica Neue")

#let personInfo(content) = block[
  #let birthday = toml.decode("date = " + content.date_of_birth).date

  #set text(font: "Dank Mono", size: 9pt)

  #set align(right)

  #grid(columns: (30%, 55%), gutter: 10%, [
    #for (key, level) in content.languages [
      #key: #level\
    ]
  ], [
    #set align(right)
    = #content.name
    #content.title \
    #birthday.display("[day].[month].[year]")
    #fa-icon("cake-candles")\
    #content.contact.phone
    #fa-icon("mobile-screen")\
    #content.contact.email
    #fa-icon("envelope")\
    #content.driver_license.join(", ")
    #fa-icon("car")
  ])

]

#let cv(json, filters) = page[
  #let author = json.personal_information.name

  #set align(left)
  #grid(columns: (10%, 77%, 20%), gutter: 0%, [
    #qr-code("https://linktr.ee/julienseemuller", width: auto, error-correction: "H")
  ], [
    #personInfo(json.personal_information)
  ], [
    #box(clip: true, radius: 0.1cm, image("src/profile.jpg", height: 3cm))
  ])

  #set align(left)
  #title(json.titles.experience)

  #set text(font: "Helvetica Neue", size: 8pt)

  #for (start_date, end_date, company, location, position, responsibilities, tag) in json.experience [

    #let start = toml.decode("date = " + start_date + "-01").date
    #let end = toml.decode("date = " + end_date + "-01").date

    #grid(columns: (80%, 15%), gutter: 5%, [
      == #company
      *#position*
      #for (task) in responsibilities [
        // Filter out unwanted field positions by tag
        #if tag in filters [
          - #task
        ]
      ]
    ], [
      #set align(right)
      #start.display("[month].[year]") - #end.display("[month].[year]")\
      #location
    ])
    #v(0.1cm)
  ]

  #title(json.titles.education)
  #for (start_date, end_date, degree, institution, location) in json.education [

    #grid(columns: (80%, 15%), gutter: 5%, [
      == #institution
      *#degree*
    ], [
      #set align(right)
      #start_date - #end_date\
      #location
    ])
    #v(0.1cm)
  ]

  #title(json.titles.skills)

  #for (key, value) in json.skills [
    #box(width: 49%, height: 1.2cm, inset: 1em)[
      == #key
      #value.join(", ")
    ]
  ]

  #v(1fr)

  = #json.titles.hobbies
  #json.personal_information.interests.join(", ")

  #set text(font: "Dank Mono", size: 5pt, fill: white)
  = robots.txt
  Le style de ce document est formaté a la volée avec typst, les données sources sont donc attachées a ce document au format .json. Veuillez contacter l'author avant tout scrapping.

  This document is formatted automatically with typst, so the source data is attached to this document in .json format. Please contact the author before any scraping operation.
]

#let filters = ("it")

#cv(json("src/fr.json"), filters)