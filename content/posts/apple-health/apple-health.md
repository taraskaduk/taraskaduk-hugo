---
title: Analyze your Apple Health data in R
author: Taras Kaduk
date: '2019-03-01'
slug: apple-health
tags: [r, personal data, productivity]
image: /posts/weather/image.png
draft: true
---

# Intro
Blah blah blah

# Get the data
Getting the data is pretty easy. From Apple Health, you can export it anywhere. I save it right away into the Files, which instantly appears in my iCloud and is accessible from my Mac.

{{% zoom-img src="/posts/apple-health/1.jpg" %}}

Your mileage may vary based on the path you chose to get the files. You could save it on the cloud, and then access via a web link, for instance. I find the iCloud storage synced up to your Mac being the most convenient solution.

Now that the zip archive is on my Mac, you can break out an R session and start proding.

# Import

DON'T FORGET TO INCLUDE LIBRARY SEGMENT

The path to a folder on iCloud when synced up with the cloud looks funny.
You're better off creating an RStudio project and landing your archive right in that folder.
But just FYI, here's the full path to the folder Data saved in the Documents folder which syncs up to iCloud.

```
path <- '~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/Data'
zip <- paste(path, 'export.zip', sep = '/')
unzip(zip, exdir = path)
```

You can also remove the .zip archive right away to prevent an override dialog on your phone next time
```
Sys.sleep(3)
file.remove(zip)
```

Now that we unzipped the archive, we can work with the actual data. First create n `xml` object containing all of the data as a starting point

```
xml <- xmlParse(paste0(path, '/apple_health_export/export.xml'))
summary(xml)
```

```
$nameCounts

                          Record                    MetadataEntry                         Location      InstantaneousBeatsPerMinute HeartRateVariabilityMetadataList 
                          469245                            73464                            50008                            18446                              456 
                    WorkoutEvent                          Workout                  ActivitySummary                      Correlation                     WorkoutRoute 
                             248                              133                              110                               71                               62 
                  ClinicalRecord                       ExportDate                       HealthData                               Me 
                              17                                1                                1                                1 

$numNodes
[1] 612263
```

Your mileage may vary based on the amount of data you store in Apple Health, and the amount of Apple devices that use Apple Health (iPhone alone or iPhone + AppleWatch).
A brief rundown is the following:

- **Record** is the main place where the data is stored. Weight, height, blood pressure, steps, nutrition data, mindful minutes - all stored here
- **ActivitySummary** is your AppleWatch daily Activity stats: Move, Exercise, Stand data
- **Workout** is AppleWatch workout activity per workout logged
- **Location** is your location logged during your AppleWatch workouts
- **InstantaneousBeatsPerMinute** is exactly that: instantaneous heart rate when measured by AppleWatch
- **ExportDate** is useful to validate what data are you looking at.

The rest is either some matadata or something that I haven't found much use from (yet)

# Analyze

Now we can take these files apart.

```
df_record <-   XML:::xmlAttrsToDataFrame(xml["//Record"])
df_activity <- XML:::xmlAttrsToDataFrame(xml["//ActivitySummary"])
df_workout <-  XML:::xmlAttrsToDataFrame(xml["//Workout"])
```