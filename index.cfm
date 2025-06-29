<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CarryClub - Premium Handbags</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@400;500;600;700&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Montserrat:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- external css -->
     <link rel="stylesheet" href="style.css">
</head>
<body>
    <cfinclude template="header.cfm">
      <!-- Carousel Section -->
      <section id="home" class="pt-4">
        <div id="mainCarousel" class="carousel slide carousel-fade" data-bs-ride="carousel">
            <div class="carousel-indicators">
                <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
                <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="1" aria-label="Slide 2"></button>
                <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="2" aria-label="Slide 3"></button>
            </div>
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="images/evening.webp" class="d-block w-100" alt="Luxury Handbags">
                    <div class="carousel-caption">
                        <h2>Welcome to CarryClub</h2>
                        <p>Discover our collection of premium handbags designed for the modern woman.</p>
                        <a href="#products" class="btn btn-colour">Shop Now</a>
                    </div>
                </div>
                <div class="carousel-item">
                    <img src="images/travel.webp" class="d-block w-100" alt="New Collection">
                    <div class="carousel-caption">
                        <h2>Summer Collection 2025</h2>
                        <p>Explore our latest designs featuring vibrant colors and innovative materials.</p>
                        <a href="#featured-collection" class="btn btn-colour">View Collection</a>
                    </div>
                </div>
                <div class="carousel-item">
                    <img src="images/luxury.webp" class="d-block w-100" alt="Handcrafted Bags">
                    <div class="carousel-caption">
                        <h2>Handcrafted Excellence</h2>
                        <p>Each CarryClub bag is meticulously crafted by skilled artisans using premium materials.</p>
                        <a href="#about" class="btn btn-colour">Our Story</a>
                    </div>
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#mainCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#mainCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <!-- <span class="carousel-control-next-icon" aria-hidden="true" style="background-color: #000000;"></span> -->
                <span class="visually-hidden">Next</span>
            </button>
        </div>
    </section>

    <!--- Get active products from database --->
    <cfscript>
        productService = new components.ProductService();
        productsData = productService.getActiveProducts();
    </cfscript>

    <!-- Product Cards Section -->
    <section id="products" class="py-5">
        <div class="container">
            <h2 class="text-center mb-5">Our Bestsellers</h2>
            <div class="row">
                <cfif productsData.success>
                    <cfoutput>
                        <cfloop array="#productsData.data#" index="product">
                            <div class="col-md-4 mb-4">
                                <div class="card h-100 small-768">
                                    <img src="#product.image#" class="card-img-top" alt="#product.name#" style="height: 250px; object-fit: cover;">
                                    <div class="card-body">
                                        <h3 class="card-title">#product.name#</h3>
                                        <p class="card-text">#product.description#</p>
                                        <p class="fw-bold">#DollarFormat(product.price)#</p>
                                        <span class="badge bg-secondary">#product.category_name#</span>
                                        <div class="mt-3">
                                            <a href="##" class="btn btn-colour" data-product-id="#product.id#">Add to Cart</a>
                                            <a href="cart.cfm" class="btn btn-colour ms-2">View Cart</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </cfloop>
                    </cfoutput>
                <cfelse>
                    <div class="col-12">
                        <div class="alert alert-info text-center">
                            <h4>No Products Available</h4>
                            <p>We're currently updating our product catalog. Please check back soon!</p>
                        </div>
                    </div>
                </cfif>
            </div>
        </div>
    </section>


    <!-- Featured Collection -->
    <section id="featured-collection" class="py-5">
        <div class="container">
            <h2 class="text-center mb-5">Summer Collection 2025</h2>
            <div class="row">
                <div class="col-md-6 col-lg-4 small-768">
                    <div class="collection-item">
                        <img src="images/c1.webp" class="img-fluid" alt="Summer Tote">
                        <div class="collection-overlay">
                            <h4>Summer Tote</h4>
                            <p class="mb-2">Vibrant colors for sunny days</p>
                            <a href="#" class="btn btn-sm btn-outline-light">View Details</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 small-768">
                    <div class="collection-item">
                        <img src="images/c2.webp" class="img-fluid" alt="Beach Bag">
                        <div class="collection-overlay">
                            <h4>Beach Bag</h4>
                            <p class="mb-2">Waterproof and spacious</p>
                            <a href="#" class="btn btn-sm btn-outline-light">View Details</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 small-768">
                    <div class="collection-item">
                        <img src="images/c3.webp" class="img-fluid" alt="Evening Clutch">
                        <div class="collection-overlay">
                            <h4>Evening Clutch</h4>
                            <p class="mb-2">Elegant design for special occasions</p>
                            <a href="#" class="btn btn-sm btn-outline-light">View Details</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 small-768">
                    <div class="collection-item">
                        <img src="images/c4.webp" class="img-fluid" alt="Crossbody Mini">
                        <div class="collection-overlay">
                            <h4>Crossbody Mini</h4>
                            <p class="mb-2">Compact and convenient</p>
                            <a href="#" class="btn btn-sm btn-outline-light">View Details</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 small-768">
                    <div class="collection-item">
                        <img src="images/c5.webp" class="img-fluid" alt="Weekender Bag">
                        <div class="collection-overlay">
                            <h4>Weekender Bag</h4>
                            <p class="mb-2">Perfect for short trips</p>
                            <a href="#" class="btn btn-sm btn-outline-light">View Details</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 small-768">
                    <div class="collection-item">
                        <img src="images/c6.webp" class="img-fluid" alt="Wallet Collection">
                        <div class="collection-overlay">
                            <h4>Wallet Collection</h4>
                            <p class="mb-2">Matching accessories</p>
                            <a href="#" class="btn btn-sm btn-outline-light">View Details</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="text-center mt-4">
                <a href="#" class="btn btn-colour">View All Collections</a>
            </div>
        </div>
    </section>

    <!-- Size Guide -->
    <section id="size-guide" class="py-5 bg-light">
        <div class="container">
            <h2 class="text-center mb-5">Handbag Size Guide</h2>
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="table-responsive">
                        <table class="table table-bordered size-guide-table">
                            <thead class="table-dark">
                                <tr>
                                    <th>Bag Type</th>
                                    <th>Small</th>
                                    <th>Medium</th>
                                    <th>Large</th>
                                    <th>Recommended For</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Tote</td>
                                    <td>10" x 8" x 3"</td>
                                    <td>14" x 11" x 4"</td>
                                    <td>18" x 14" x 6"</td>
                                    <td>Work, Shopping, Daily Use</td>
                                </tr>
                                <tr>
                                    <td>Crossbody</td>
                                    <td>7" x 5" x 2"</td>
                                    <td>9" x 7" x 3"</td>
                                    <td>12" x 9" x 4"</td>
                                    <td>Travel, Everyday Essentials</td>
                                </tr>
                                <tr>
                                    <td>Clutch</td>
                                    <td>6" x 4" x 1"</td>
                                    <td>8" x 5" x 2"</td>
                                    <td>10" x 6" x 2"</td>
                                    <td>Evening Events, Formal Occasions</td>
                                </tr>
                                <tr>
                                    <td>Backpack</td>
                                    <td>10" x 8" x 4"</td>
                                    <td>13" x 11" x 5"</td>
                                    <td>16" x 13" x 6"</td>
                                    <td>School, Travel, Outdoor Activities</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="card mt-4">
                        <div class="card-body">
                            <h4 class="card-title">How to Measure Your Bag</h4>
                            <p class="card-text">To ensure you select the right size bag for your needs, measure as follows:</p>
                            <ul>
                                <li><strong>Width:</strong> Measure across the bag at its widest point</li>
                                <li><strong>Height:</strong> Measure from the bottom to the top of the bag</li>
                                <li><strong>Depth:</strong> Measure from front to back at the widest point</li>
                            </ul>
                            <p class="card-text">Not sure which size is right for you? Contact our customer service for personalized recommendations.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonials -->
    <section id="testimonials" class="py-5">
        <div class="container">
            <h2 class="text-center mb-5">What Our Customers Say</h2>
            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="card testimonial-card h-100">
                        <img src="images/test3.jpg" alt="Customer 1">
                        <h4>Shalija</h4>
                        <div class="star-rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                        <p>"I've been using my CarryClub tote for over a year now, and it still looks brand new! The quality is exceptional, and I receive compliments everywhere I go."</p>
                        <small class="text-muted">Purchased: Elegant Tote</small>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card testimonial-card h-100">
                        <img src="images/test2.jpg" alt="Customer 2">
                        <h4>Khushi</h4>
                        <div class="star-rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star-half-alt"></i>
                        </div>
                        <p>"The Crossbody Classic is perfect for my busy lifestyle. It's spacious enough for all my essentials but not bulky. The leather is soft and the hardware is sturdy."</p>
                        <small class="text-muted">Purchased: Crossbody Classic</small>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card testimonial-card h-100">
                        <img src="images/test1.jpg" alt="Customer 3">
                        <h4>Anjali</h4>
                        <div class="star-rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                        <p>"I bought the Mini Clutch for my wife's birthday, and she absolutely loves it! The craftsmanship is outstanding, and the customer service was exceptional."</p>
                        <small class="text-muted">Purchased: Mini Clutch</small>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- About Us Section -->
    <section id="about" class="py-5">
        <div class="container">
            <h2 class="text-center mb-5">About CarryClub</h2>
            <div class="row align-items-center">
                <div class="col-md-6 mb-4 mb-md-0">
                    <img src="images/everyday.webp" class="img-fluid rounded small-768" alt="About CarryClub">
                </div>
                <div class="col-md-6">
                    <h3>Our Story</h3>
                    <p>Founded in 2010, CarryClub began with a simple mission: to create beautiful, functional handbags that empower women in their daily lives. What started as a small workshop has grown into a beloved brand known for quality craftsmanship and timeless designs.</p>
                    <p>Each CarryClub bag is meticulously crafted by skilled artisans using premium materials sourced from ethical suppliers. We believe in creating products that not only look beautiful but are built to last.</p>
                    <!-- Dropdown Component -->
                    <div class="dropdown mt-4 mb-4">
                        <button class="btn btn-secondary w-100 dropdown-toggle" type="button" id="aboutDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            Know More About CarryClub
                        </button>
                        <ul class="dropdown-menu w-100" aria-labelledby="aboutDropdown">
                            <li><a class="dropdown-item" href="#team">Our Team</a></li>
                            <li><a class="dropdown-item" href="#craftsmanship">Craftsmanship</a></li>
                            <li><a class="dropdown-item" href="#sustainability">Sustainability</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="#careers">Careers</a></li>
                        </ul>
                    </div>
                    <h3>Our Mission</h3>
                    <p>To design and craft exceptional handbags that combine functionality, style, and sustainability, enhancing the lives of our customers while respecting our planet.</p>
                </div>
                    
            </div>
        </div>
    </section>

    <!-- Contact Form Section -->
    <section id="contact" class="py-5">
        <div class="container">
            <h2 class="text-center mb-5">Contact Us</h2>
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <form>
                        <div class="row mb-3">
                            <div class="col-md-6 mb-3 mb-md-0">
                                <input type="text" class="form-control" placeholder="Your Name" required>
                            </div>
                            <div class="col-md-6">
                                <input type="email" class="form-control" placeholder="Your Email" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <input type="text" class="form-control" placeholder="Subject" required>
                        </div>
                        <div class="mb-3">
                            <textarea class="form-control" rows="5" placeholder="Your Message" required></textarea>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-colour">Send Message</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <cfinclude template="footer.cfm">

        <!-- Scroll to top button -->
        <a href="#home" class="position-fixed bg-danger text-white rounded-circle d-flex justify-content-center align-items-center shadow Scroll back-to-top" >
            <i class="fas fa-chevron-up"></i>
        </a>
    
        <!-- Bootstrap JS Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <!-- jQuery (New) -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- Custom JS -->
        <script src="script.js"></script>
    </body>
    </html>    