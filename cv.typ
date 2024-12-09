#import "@preview/fontawesome:0.5.0" : fa-icon
#import "@preview/cades:0.3.0" : qr-code

#set page(
  paper: "a4", 
  margin: 1cm,
)

#let title(body) = [
  #set text(
  size: 12pt,
  font: "Helvetica Neue",
  )
  = #body
  #line(
    length: 100%,
    stroke: (thickness: 1pt, dash: "loosely-dotted")
  )
]

#set text(
  size: 12pt,
  font: "Helvetica Neue",
)

#let personInfo(content) = block[
  #let birthday = toml.decode("date = " + content.date_of_birth).date

  #set text(
    font: "Dank Mono",
    size: 9pt
  )

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

  #line()

  #for (key, level) in content.languages [
    #key: #level\
  ]
]

#let cv(json) = page[
  #let author = json.personal_information.name

  #set align(right)
  #grid(
    columns: (20%, 55%, 25%),
    gutter: 0%,
    [#qr-code(
      "https://linktr.ee/julienseemuller",
      height: 3.85cm,
      error-correction: "L"
    )],
    [#personInfo(json.personal_information)], 
    [  
      #box(
        clip: true, radius: 0.1cm,
        image("src/profile.jpg", height: 4.85cm)
      )
    ] 
  )

  #set align(left)
  #title("Experience")  


  #set text(
    font: "Roboto",
    size: 8pt
  )

  #for (start_date, end_date, company, location, position, responsibilities) in json.experience [  
  #let start = toml.decode("date = " + start_date + "-01").date
  #let end = toml.decode("date = " + end_date + "-01").date


  #grid(
    columns: (60%, 35%),
    gutter: 5%,
    [
      == #company
      #position
      #for (task) in responsibilities [
        - #task
      ]
    ],
    [
      #set align(right)
      #start.display("[month].[year]") - #end.display("[month].[year]")\ 
      #location
    ],
  )

  #line(stroke: gray)

  ]

  #title("Education")  
]

#cv(json("src/fr.json"))

#pagebreak()
= Debug
#json("src/fr.json")