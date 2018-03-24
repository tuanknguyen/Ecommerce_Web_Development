# Ecommerce_Web_Development

## Project Description
This project offers an e-commerce platform for young fashion designers in Vietnam to list directly sell their products to consumer in small quantities.
This repository is a sample code of the website written in Ruby on Rails. The backend is a PostgreSQL database while frontend is mostly in HTML/CSS, and JS.

Please visit the [demo website](https://dearemalpha.herokuapp.com/) to see the full functionalities.

## Tech
### Backend
- Backend is PostgreSQL database hosted on Heroku. A small service is created to ping the website at fixed interval to keep it from *sleeping*.
- The CDN service used is Cloudflare. It keeps copies of the web distributed among targeted geographical regions for faster loading time.
### Frontend
- Mobile-friendly!! Will work for all screen size
- Mostly use the Bootstrap framework 
- Use of Fontello and Fontawesome
- All CSS and JS files are compressed using minify to shorten load time
- Custom JS are written for many purposes: input validation, animation of adding items to cart... 

## Features!!
- New sign ups will be placed in one of three groups in decreasing order of acess rights: the website admins, the designer or shop owners, and shoppers.
- Products created will be placed in one of the few categories defined by the website admin, for e.g. dress, top, jeans... A product can belong to multiple category.
- Shopper can select size and color of a product before adding to cart.
- A preview of a cart is generated before checkout, where shoper can view and edit their items, as well as the cost of shipping based on their location.
- After choosing a payment method and checkout, a confirmation email and a copy of the receipt will be emailed to the shopper.
- Designers or shop owners can create a promotion for a certain duration. 
- Shoper will be notified when the product is out of stock or is selling out soon, for e.g. only 2 items left.
- A preview of similar items (of the same tags) to the current items is shown near the bottom of the page.
