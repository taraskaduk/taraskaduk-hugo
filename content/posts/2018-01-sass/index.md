---
title: On Importance of Minimalism in Retrospective Analytics
author: Taras Kaduk
date: '2018-01-12'
slug: sass
categories: Essays
tags: [data analytics & business intelligence]
comments: true
---

Hey, analyst, how is life? Talk to me. Do you love what you do for life, do you like all things data?

Yet, do you sometimes feel like you’re a Sisyphus rolling a giant rock of data up the hill every day, only to see it go down with a racket in the evening (and you know what you’re going to do tomorrow)? Or, do you imagine yourself being a plate spinner at a circus, only instead of plates and poles you’ve got five dozen reports to spin, and instead of an entertained crowd you’ve got your co-workers, managers and senior executives watching your “performance” and asking to add more plates, and God forbid any one plate falls?

The truth is — herding your reporting under one roof is no small feat. It is especially challenging at times, when you need to create a unified business solution from bits and pieces: Excel spreadsheets, Access databases, and built-in reports older than some of your employees. Create it and then maintain it. Oh my.

It doesn’t help that such enormous task usually receives minimal funding, as you are basically “fixing” something that “ain’t broke”.

It’s OK. I’ve been there. Coming to the office all excited to work with data and create some mad data viz and publish it, only to get a hard kick in a sensitive area with one report not refreshing, another report having errors, and with a dozen more requests to spin off more of the same.

---

# The SASS Framework

But it doesn’t have to be this way. Over the years, my team and I have managed to develop a simple framework for dealing with this kind of plate-spinning environment. We are a very lean team, but we manage to accomplish a lot, with minimum time spent fixing what’s broken and/or doing anything that resembles what’s been done before.

The secret sauce here is optimizing for time. You don’t have the capacity to create isolated one-time-only solutions, to fix things on a regular basis, to perform manual updates, to enter data, you’ve got time for none of that. Much like professional cyclists reduce the weight of a bicycle by replacing parts, trimming of edges of nuts and bolts and drilling holes through bike pipes, you need to save as much time as possible by shaving off all the nonessential movements.

I call our result approach the SASS framework. SASS here stands for simple, automated, standard and scalable. Building your work around these four “standards” would help you get out of the self-perpetuated loop of constant plate-spinning.

Applying this framework is simple. You ask these 4 questions on simplicity, automation, standard and scale. Furthermore, they are applicable on every stage of you data’s journey: whether you only take on a new request, build out a report, or deploy it for continuous consumption.

Below, I’ll show you some examples of what it means.

---

## Simple

Do you reports suffer from abundance of KPIs, complicated data models, transformation steps no one understands? Take a step back and simplify it. Keep your data tidy and your calculations simple. Your code should be laconic, elegant and easy to read. For me, complicated code is the first sign of a possible trouble. Do you have to many visuals? More opportunities of something failing. Reduce. Do have multiple reports running doing a similar thing? Reduce the amount and consolidate them. Keep it simple.

## Automated

> “That which does not kill us, makes us stronger.” **~Nietzsche**

Well… then redundant work definitely doesn’t make me stronger. It slowly kills me. And it kills me seeing other people doing it.

A wise man once said: “Life is too short to do what can be automated”. He also said: “Automate until it hurts”. (Sadly, he wasn’t heard and his wisdom almost vanished. But then he decided to write this blog post)

Do your data sources refresh automatically? Do you script all of your transformations (be it SQL, R, Python, Power Query, or a screen grab script), or do you perform any actions manually (save a file, format a spreadsheet, paste a table etc)? Is your solution on a scheduled refresh, or do you have click on things?

It is tempting to let some of the manual action slip in as “no big deal”. That’s fine and dandy when you have 5–10 reports to maintain. Scale it up to 50 — and your “no big deal” adds up to staying late and spending weekends running shit you’re not supposed to.

You’re too valuable to do some script’s dirty job.

## Standard

This one must be simple and obvious. Keeping things standard again means more time savings: less validation, less discovery time, less training and explaining.

Do you use one record of truth, the data from one lake? If half your analysts use one source (say, a new database on the cloud) and another half is running stored procedures written before the times of Noah’s Ark, then don’t get surprised if the two teams end up with a different number.

Do you and/or your team adhere to the same visual design principles? Nothing beats bars and lines, and nothing beats simple colors. Most of our recurring reporting looks pretty plain and boring: it is bars, lines and tables; and the color is designated to carry a specific data point and almost never used just for the looks. Yeah, it isn’t fun, but you avoid the decision fatigue, you save time by not coming up with a new palette and new outline, and you don’t spend time explaining your audience what this new spider web chart means and how to read it. Don’t get me wrong, I’m not against new reports, cool colors, interesting and fresh charts — I’m just showing you where to save time and resources when you need to maintain a large number of such reports.

## Scalable

After all said and and done, you should be able to repurpose your logic for something else. Or scale it within the given context. Similarly, many solutions can be created on top of some previous work, instead of creating a new solution. This also makes sure your solutions are “standardized”: you kill 2 birds with 1 stone.

In our line of work, we’ve created several large data models for financial, sales and operational data, and most of the existing and new reports feed off these data models. We save a lot of time deploying new solutions because most of the work is already done and the data models have been built in such a way that we easily can scale it for something new.

Of course, this minimalist approach in retrospective analytics is not for everyone. There are different roles in the world of data science, and different tactics work for each role. The SASS framework is mostly applicable to the teams or individuals responsible for running a large suite of recurring reporting within a mid to large size company.

Let me know if you’re facing similar struggles at work and if you have different solutions in place!