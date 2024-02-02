### !!!! IMPORTANT !!!!! ###
## This code won't run properly for you until you authorise it to access your google account,
## and make a google sheets that it can write the submissions to.

### HOW TO DO THIS

# first, you will need to install and load the following packages (shiny already comes with R)

library(shiny)
library(shinyjs)
library(googlesheets4)
library(googledrive)

# These first few bits of code (making the google sheet, authorising the account), only need to be run once, 
# so they are commented out now. Just uncomment them and run them once the first time you set up your app, then 
# comment them out again once you deploy it.

## 1. SET UP AUTHORISATION TO EDIT FILES IN YOUR GOOGLE DRIVE

# Get the token and store it in a cache folder embedded in your app directory
# designate project-specific cache

options(gargle_oauth_cache = ".secrets")

# The line below (drive_auth()) is used to authenticate your google account. Uncomment it and run the app ONCE, then check if the token 
# has been stored inside the .secrets folder, after that just comment out the line again (or it will ask you to sign in every time you run the app)

# drive_auth() # Authenticate to produce the token in the cache folder

# Tell gargle to search the token in the secrets folder and to look
# for an auth given to a certain email (enter your email linked to googledrive!)

drive_auth(cache = ".secrets", email = "YOUREMAIL@gmail.com")
gs4_auth(token = drive_token())

## 2. Make google sheet

# You only need to make the google sheet once, so uncomment the line below and run it in your console to make the google sheet, then comment it out again

# ss <- gs4_create("SurveyData")

# Run the code below in your console to get the sheet ID

# ss[1]

# Copy and paste the sheet ID from the console, storing it in the variable sheet_ID (replace the XXXXXXs here with your sheet ID)

sheet_ID <- "XXXXXXXXXXXXXXXXXXXXX"

# Congratulations, now this shiny app will be able to write to your google sheet!

### CODE FOR THE APP ITSELF

# I found that the app loads much faster if instead of having the csv file and reading the csv file, we just hard code
# the image links and names. So that's why I've done this instead here.
# If you had really a lot of stimuli though it would probably be worth the longer loading time to read the csv file

# Make a vector to store the image links
images <- c(
  "https://www.brides.com/thmb/jfyHBWikMeTVowZL68mp3vW1lEA=/1197x1388/filters:fill(auto,1)/aef-a1eb0550df2645e581844a61585422ac.png",
  "https://cdn.valio.fi/mediafiles/48ec6532-3015-4a25-a0dc-c1f8078decf0/1600x1200-recipe-data/4x3/fodelsedagstarta-med-hallon-och-blabar.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Raspberry_tart.jpg/1200px-Raspberry_tart.jpg",
  "https://tmbidigitalassetsazure.blob.core.windows.net/rms3-prod/attachments/37/1200x1200/exps6086_HB133235C07_19_4b_WEB.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/f/fa/Freshly_baked_gingerbread_-_Christmas_2004.jpg",
  "https://files.allas.se/uploads/sites/25/2020/04/citronkaka-med-glasyr-2-700x920-1280.jpg",
  "https://s3.amazonaws.com/finecooking.s3.tauntonclud.com/app/uploads/2017/04/18182727/051054w-Dodge-Lemon-Tart-main.jpg",
  "https://imageresizer.static9.net.au/tPvl31oEOzRCSBjPofR2I8J-Od8=/1200x675/https%3A%2F%2Fprod.static9.net.au%2F_%2Fmedia%2Fnetwork%2Fimages%2F2019%2F01%2F06%2F11%2F43%2Fbiscuits.jpg",
  "https://d2rfo6yapuixuu.cloudfront.net/h65/h7c/8857136431134/07310960016403.jpg_master_axfood_400",
  "https://upload.wikimedia.org/wikipedia/commons/2/2b/SemlaFlickr.jpg",
  "https://www.thespruceeats.com/thmb/LztCwx-RV2XEcA9MuOG5Oqf7D44=/1606x1070/filters:fill(auto,1)/quick-cinnamon-rolls-3053776-81543bd7548c4b7fa95b8c51aaec316d.jpg",
  "https://cookinglsl.com/wp-content/uploads/2016/10/apple-pull-apart-bread-2-1.jpg",
  "https://tmbidigitalassetsazure.blob.core.windows.net/rms3-prod/attachments/37/1200x1200/exps9018_FB153741B05_27_4b.jpg",
  "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/brioche-597b5f8.jpg",
  "https://files.allas.se/uploads/sites/31/2014/10/langpanna.jpg"
)

# Name the links so you know what image they refer to
names(images) <- c(
  "Wedding cake",
  "Birthday cake",
  "Raspberry tart",
  "Apple pie",
  "Gingerbread biscuits",
  "Lemon cake",
  "Lemon tart",
  "Oreos",
  "Wienerbröd",
  "Semla",
  "Cinammon scroll",
  "Apple pullapart",
  "Round pullapart",
  "Brioche",
  "Raspberry slice"
)

# we haven't learnt this, but vectors can be associated with names, and then you can use those 
# names to access items in the vector. Try uncommenting and running the code below to see how it works

# images["Wedding cake"]

# Let's now plan what demographic information we will collect from participants

demographics <- c("NativeLang","Otherlangs","Birthplace","Residence","Age","Gender","SubmissionTime")

# the submission time is not demographic information, but I decided to record the submission time for each
# participant so that we have a way of uniquely identifying participants later

# Let's make the first row in the google sheet the names of the stimuli, plus the demographic information we are collecting
# these will be the column names in our csv file of results, and every submission will be one row in the file
# You only need to uncomment this and do this once.

# sheet_append(data.frame(t((data.frame(c(names(images),demographics))))),ss=sheet_ID)

### MAKING THE EXPERIMENT

# make a list of labels for the cakes
labels <- c("tårta","paj","kaka","bakelse","bulle","keks","bakverk","bröd","ruta","bit")

# make a list of swedish regions for feedback
regions <- c("Jag kommer inte från Sverige","Blekinge","Bohuslän","Dalarna","Dalsland","Gotland","Gästrikland","Halland","Hälsingland","Härjedalen","Jämtland","Lappland","Medelpad","Norrbotten","Närke","Öland","Östergötland","Skåne","Småland","Södermanland","Uppland","Värmland","Västmanland","Västerbotten","Västergötland","Ångermanland")
borregions <- c("Jag bor inte i Sverige","Blekinge","Bohuslän","Dalarna","Dalsland","Gotland","Gästrikland","Halland","Hälsingland","Härjedalen","Jämtland","Lappland","Medelpad","Norrbotten","Närke","Öland","Östergötland","Skåne","Småland","Södermanland","Uppland","Värmland","Västmanland","Västerbotten","Västergötland","Ångermanland")

# we want to show the images in a random order, so create a
# vector of the names of the images in a random order 
# the order of names in the vector will be different every time the app is run; 
# so we get a unique order for every participant
image_order <- sample(names(images))

# create the user interface

ui <- fluidPage(
  # we need to include this function in order to have some parts of our experiment hidden at the start
  useShinyjs(),
  
  # main panel refers to the main part of the webpage, where we will display everything
  mainPanel(
    titlePanel("Kakenkät"),
    # enclose everything that you want to treat as one unit to hide and show at different times in a div
    # our first div contains the instructions for the experiment, plus a button to participate
    div(id="instructions",
        includeHTML('instructions_swe.html'),
        actionButton("Participate","Delta")),
    
    # our second div is where we have the experiment itself, this consists of an image, 
    # some radio buttons with the labels for the image
    # plus one free text field for people to add their own labels
    hidden(div(id="experiment",
               # uiOutput() is the most general placeholder function for output
               # when you want to output R plots etc., I would use plotOutput() instead
               # but uiOutput() is good if you just want to output raw html code, like for our cake images
               uiOutput("Stimulus"),
                                          # by default it will load with the first label selected, here we set it so nothing is selected at first
               radioButtons("Choice","Vad är detta?",labels,selected = character(0)),
               textInput("Other","Andra (skriv ditt svar här):"),
               actionButton("Next","Nästa"))),
    
    # our third div is what the user sees when they finish the survey; i.e. the demographic questions
    hidden(div(id="exitques",
               # the h1(), h2(), h3() etc. functions make headings of different sizes; h1() is bigger than h2(), etc.
               h3("Tack för ditt deltagande."),
               textInput("NativeLang","Modersmål:"),
               textInput("OtherLangs","Andra språk du talar:"),
               textInput("Birthcountry","Hemland:"),
               selectInput("HomeRegion","Om ditt hemland är Sverige, vilket län kommer du ifrån?",regions),
               selectInput("CurrentRegion","Om du bor i Sverige, vilket län bor du i?",borregions),
               selectInput("Age","Ålders grupp:",c("Under 20","20-29","30-39","40-49","50-59","60-69","70+")),
               selectInput("Gender","Kön:",c("Man","Kvinna","Ickebinär")),
               actionButton("Submit","Skicka in")
    )),
    
    # and our last input is what they see when they click submit; a message saying thank you
    hidden(div(id="submitted",h3("Dina svar har nu skickats in, tack!")))
    
  ))

# the server is where we make stuff happen in our user interface
# we had ids, and two names for everything, in the ui so that we can use these first names/ids to refer to
# things in the server

server <- function(input,output,session){
  
  # again, we need to use javascript so we can show and hide things
  useShinyjs()
  
  # "Participate" is what we called our first action button (the participate button) in the ui
  onclick("Participate", {
    show("experiment")
    hide("instructions")
    
    # for every output function in the ui (e.g. uiOutput, plotOutput etc.) we need a corresponding 
    # renderUI(), renderPlot() function etc. in the server, where we generate the image/plot
    
    # outputs are refered to using output$ID. Here, we called out uiOutput "Stimulus" (the ID is always the
    # first argument in the uiOutput()/plotOutput() etc. function in the ui)
                                       
                                       # take the first item in image_order
                                       # that will be the name of one of the images (e.g. Wienerbröd)
                                       # use that to access the link to itself which is stored in images
                                       # under that name
    
                                      # images[image_order[1]] returns both the name of the image and its link
                                      # to get just the link only, use images[image_order[1]][[1]]
                                      # using [[]] instead of just [] drops any names from the thing it returns
    output$Stimulus <- renderUI(tags$img(src=images[image_order[1]][[1]],height=150,width=150))
    # setting output$Stimulus to the image in renderUI() will render an image in the placeholder uiOutput("Stimulus") in our ui
  })
  
  # make a variable, count, to count how many images we have shown to participants so far 
  # in this case, we've already shown the first image when they clicked participate
  count <- 1
  
  # make a vector to store the participant's choices, which will be the length of the number of images that we have.
  # Right now I've just made it a vector of numbers 1 to the length of the images vector, but we're going to replace
  # those numbers with their answers as they complete the experiment
  
  # the reason I've made it a vector of numbers instead of just an empty vector is because I want to store the 
  # participants responses to the stimuli in this vector in the same order as the stimuli are 
  # in the columns in the google sheet
  # this means that we need a place for every image already, so we can insert them in the right place when the time
  # comes using indexing -- this will make more sense as you keep reading the code below
  results <- c(1:length(images))
  
  onclick("Next",{
    # If someone types something into the 'other' field, when they click next, what they typed into 'other' will still
    # be visible unless we update the text input to be nothing again
    
    if(input$Other!=""){updateTextInput(session, "Other", value = "")}
    
    # the first thing we need to do is store the input from the last image the user was shown (before they clicked 'Next')
    
    # the match function is from stringr, it returns the index of a given item 
    # (whatever stimulus name is at image_order[count]) in a vector (the names of our images)
    results_index<-match(image_order[count],names(images))
    
    # we want to store our results in the same order that they are in names(images), because this is the order
    # of the columns in our google sheet
    results[results_index]<-input$Choice
    
    # once we've stored the result from the last item, we need to update our count
    count <- count + 1
    
    # if we haven't finished showing all the images yet
    if(count<=length(images)){
      # show the next image in the count
      output$Stimulus <- renderUI(tags$img(src=images[image_order[count]][[1]],height=150,width=150))}
    else{
      # hide the experiment, and show the exit questions
      hide("experiment")
      show("exitques")
      
    }
  })
  
  onclick("Submit", {
    # what we want to append to our google sheets when they click submit is their responses to the stimuli, plus all their demographic information
    # the very last thing I have included is the system time in the format day month date time
    # this will record the time when the user clicked submit, and we're going to keep that to use to identify unique submissions
    answer <- c(results,input$NativeLang,input$OtherLangs,input$Birthcountry,input$HomeRegion,input$CurrentRegion,input$Age,input$Gender,format(Sys.time(), "%a %b %d %X %Y"))
   
    # the sheet_append function appends stuff to our google sheet
    # the only annoying thing is you have to give it an entire dataframe, it won't take just a vector
    # and when we do as.data.frame() on our answer vector, it puts the vector into a column instead of a row, 
    # so I use the t() function, which stands for transpose, to turn it into a row. The t function also 
    # only takes a data frame as input (not a vector)
    
    sheet_append(as.data.frame(t(answer)),ss=sheet_ID)
    show("submitted")
    hide("exitques")
  })
  
  # this is one little function I didn't show you in class
  # when people type stuff into other, we actually need to add what they type to our radio button choices for it
  # to record this as their choice
  # this function does that whenever there is some input to other
  
  observeEvent(input$Other, {
    if(input$Other!=""){
      updateRadioButtons(session, "Choice", choices = c(labels, input$Other), 
                         selected = input$Other)}
      })
  
  
}

shinyApp(ui=ui,server=server)