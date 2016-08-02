generalizeCategories <- function(categories){
# code derived from this discussion on kaggle: 
# https://www.kaggle.com/nickdudaev/talkingdata-mobile-user-demographics/categorizing-labels/discussion 
  
  categories$generalized <- NA
  categories[grepl('([gG]am)|([pP]oker)|([cC]hess)|([pP]uzz)|([bB]all)|([pP]ursu)|([fF]ight)|([sS]imulat)|([sS]hoot)',
                  categories$category), "generalized"] <- "Games"
  categories[grepl('(RPG)|(SLG)|(RAC)|(MMO)|(MOBA)', 
                   categories$category), "generalized"] <- "Games"
  remaining_games <- c('billards', 'World of Warcraft', 'Tower Defense', 'Tomb',
                       'Ninja', 'Europe and Fantasy', 'Senki', 'Shushan', 
                       'Lottery ticket', 'majiang', 'tennis', 'Martial arts')
  categories[categories$category %in% remaining_games, "generalized"] <- "Games"
  categories[grepl('([eE]state)', categories$category), "generalized"] <- "Property"
  categories[categories$category %in% c('Property Industry 2.0', 'Property Industry new',
                                        'Property Industry 1.0'), 
             "generalized"] <- "Property"
  categories[grepl('([fF]amili)|([mM]othe)|([fF]athe)|(bab)|([rR]elative)|([pP]regnan)|([pP]arent)|([mM]arriag)|([lL]ove)',
                   categories$category), "generalized"] <- "Family"
  categories[grepl('([fF]un)|([cC]ool)|([tT]rend)|([cC]omic)|([aA]nima)|([pP]ainti)|([fF]iction)|([pP]icture)|(joke)|([hH]oroscope)|([pP]assion)|([sS]tyle)|([cC]ozy)|([bB]log)',
                   categories$category), "generalized"] <- "Fun"
  categories[categories$category %in% c('Parkour avoid class', 'community', 
                                        'Enthusiasm', 'cosplay', 'IM'),
             "generalized"] <- "Fun"
  categories[grepl("Personal Effectiveness", categories$category),
             "generalized"] <- "Productivity"
  
  
  categories[grepl('([iI]ncome)|([pP]rofitabil)|([lL]iquid)|([rR]isk)|([bB]ank)|([fF]uture)|([fF]und)|([sS]tock)|([sS]hare)',
                   categories$category), "generalized"] <- "Finance"
  categories[grepl('([fF]inanc)|([pP]ay)|(P2P)|([iI]nsura)|([lL]oan)|([cC]ard)|([mM]etal)|([cC]ost)|([wW]ealth)|([bB]roker)|([bB]usiness)|([eE]xchange)',
                   categories$category), "generalized"] <- "Finance"
  categories[categories$category %in% c('High Flow', 'Housekeeping', 'Accounting', 
                                        'Debit and credit', 'Recipes', 
                                        'Heritage Foundation', 'IMF'),
             "generalized"] <- "Finance"
  categories[categories$category == "And the Church", "generalized"] <- "Religion"
  categories[grepl('([sS]ervice)', categories$category), "generalized"] <- "Services"
  categories[grepl('([aA]viation)|([aA]irlin)|([bB]ooki)|([tT]ravel)|([hH]otel)|([tT]rain)|([tT]axi)|([rR]eservati)|([aA]ir)|([aA]irport)',
                   categories$category), "generalized"] <- "Travel"
  categories[grepl('([jJ]ourne)|([tT]ransport)|([aA]ccommodat)|([nN]avigat)|([tT]ouris)|([fF]light)|([bB]us)',
                   categories$category), "generalized"] <- "Travel"
  categories[categories$category %in% c('High mobility', 'Destination Region', 
                                        'map', 'Weather', 'Rentals'),
             "generalized"] <- "Travel"
  categories[grepl('([cC]ustom)', categories$category), "generalized"] <- "Custom"
  categories[categories$category %in% c('video', 'round', 'the film', 'movie'),
             "generalized"] <- "Video"
  shopping <- c('Smart Shopping', 'online malls', 'online shopping by group, like groupon', 
                'takeaway ordering', 'online shopping, price comparing', 'Buy class', 
                'Buy', 'shopping sharing', 'Smart Shopping 1', 'online shopping navigation')
  categories[categories$category %in% shopping, "generalized"] <- "Shopping"
  education <- c('literature', 'Maternal and child population', 'psychology', 'exams', 'millitary and wars', 'news', 
                 'foreign language', 'magazine and journal', 'dictionary', 
                 'novels', 'art and culture', 'Entertainment News', 
                 'College Students', 'math', 'Western Mythology', 
                 'Technology Information', 'study abroad', 
                 'Chinese Classical Mythology')
  categories[categories$category %in% education, "generalized"] <- "Education"
  vitality <- c('vitality', '1 vitality', 'sports and gym', 'Health Management',
                'Integrated Living', 'Medical', 'Free exercise', 'A beauty care', 
                'fashion', 'fashion outfit', 'lose weight', 'health', 
                'Skin care applications', 'Wearable Health')
  categories[categories$category %in% vitality, "generalized"] <- "Vitality"
  categories[categories$category %in% c('sports', 'Sports News'),
             "generalized"] <- "Sports"
  categories[categories$category == "music", "generalized"] <- "Music"
  categories[is.na(categories$generalized), "generalized"] <- "Other"
  
  categories
  
}