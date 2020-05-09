![Hero Image](/ShopLyft.png)
# ShopLyft
## E-commerce Application

An E-commerce application built using Flutter, with a Firebase serverless backend.

**Features**
- Sign Up/Login
- Auto Login / Auto Logout (when token expires)
- Add products to Favourites
- Add/Remove products in the cart
- Number of items in the cart is displayed on the cart icon as a badge on the top right, for better UX
- Cart Items are dismissible, which allows the user to swipe them out of the screen to remove them from the cart
- Change quantities of the products right from the cart screen
- Product Overview page loads the images from the internet gracefully, displaying skeleton images while the actual content loads
- View Product Images in fullscreen by clicking on the preview image in the Product Details screen
- Snackbars at the bottom of the screen to undo certain actions such as adding products to cart by mistake
- View products by category
- View previous orders, and view detailed order summaries
- Add/Edit/Remove your own products in the marketplace.
- Edit Products Screen allows you to see a preview of your product images right inside the app, before you publish them to the database.

---


## Steps to use
- Clone the repo
- run the folowing to install the dependencies
```
flutter pub get
```
- Build a project on the FireBase using RealtimeDB
- The application adds entries in the following heirarchy to your Database
```
{
  "orders" : {
    <Unique order ID> : {
      <unique user ID> : {
        "amount" : <Double>,
        "dateTime" : <ISO DateTime String>,
        "products" : [ {
          "id" : <Unique Product ID>,
          "price" : <Double>,
          "quantity" : <Integer>,
          "title" : <String>
        }, {
          "id" : <Unique Product ID>,
          "price" : <Double>,
          "quantity" : <Integer>,
          "title" : <String>
        } ]
      }
    },
  },
  "products" : {
    <Unique product ID> : {
      "category" : <String>,
      "creatorId" : <User Token ID>,
      "description" : <String>,
      "imageUrl" : "https://<URL>.jpg",
      "price" : <Double>,
      "title" : <String>
    },
  },
  "userFavourites" : {
    <User Token ID> : {
      <Unique Product ID> : true
    },
  }

```
- Add your Firebase API Keys inside a secrets file in your lib folder (refer to the .gitignore for the dir-path)

---

This application was built as a part of my VI Semester Android Application Development project at MIT, Manipal.