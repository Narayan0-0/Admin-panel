component {
    this.name = "CarryClub";
    this.applicationTimeout = createTimeSpan(0, 2, 0, 0);
    this.sessionManagement = true;
    this.sessionTimeout = createTimeSpan(0, 0, 30, 0);
    
    // Define datasource
    this.datasource = "carry_club";
    
    // Define mappings if needed
    this.mappings = {
        "/includes" = expandPath("./includes"),
        "/components" = expandPath("./components"),
        "/admin" = expandPath("./admin")
    };
    
    // Application startup
    function onApplicationStart() {
        application.dsn = "carry_club";
        return true;
    }
    
    // Session startup
    function onSessionStart() {
        session.cart = [];
        session.user = {};
    }
    
    // Request startup
    function onRequestStart(targetPage) {
        if(structKeyExists(url, "reset") && url.reset) {
            applicationStop();
            sessionInvalidate();
            location(url=targetPage, addToken=false);
        }
        return true;
    }
}
