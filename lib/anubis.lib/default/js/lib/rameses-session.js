var Socket = new function() {

    function HttpSocket ( channel ) {
        if (!channel) {
            alert('channel must be provided!');
            throw new Error('channel must be provided!');
        }	

        var self = this;
        var _channel = channel;
        var _token =  Math.floor(Math.random()*1000000001) + '-' + Math.floor(Math.random()*1000000001);
        var _running = false;

        this.handlers = {};
        this.error;

        this.getToken = function() {
        	return _token; 
        } 

        var poll = function() { 
        	if (_running == false) return; 

			try {
				$.ajax({ 
					url: "/poll/"+_channel+"/"+_token, 
					dataType: 'text',
					cache: false, 
					complete: function(o,textStatus) {
						if (o.statusText == 'OK' ) {
							var result = null;
							if (o.responseText) { 
								try { 
									result = $.parseJSON(o.responseText); 
								} catch(e) {
									if (window.console) window.console.log("ERROR parsing caused by " + e + " responseText->" + o.responseText); 
								} 
							}  

							if (result) {
								var list = null; 
								if ( Array.isArray( result ) ) {
									list = result; 
								} else {
									list = [result]; 
								}

								for ( var idx=0; idx < list.length; idx++ ) {
									var item = list[ idx ]; 
									for( var n in self.handlers ) {
										try {
											self.handlers[n]( item );
										} catch(e){;} 
									} 
								} 
							} 
							setTimeout( poll, 1000 );
						} 
					} ,
					error: function(o,textStatus,msg) {
						if(textStatus=="timeout") {
							poll();
						} else {
							if( self.error ) {
								self.error( o );
							} else {
								if( window.console ) window.console.log( "Error in polling. " + o.error);
								//reconnect after 30 seconds
								setTimeout( poll, 10000 );
							}    
						}
					}
				});
			} 
			catch(e) { 
				if (window.console) window.console.log("[ERROR]_poll caused by " + e); 
			} 
        } 
        
        this.start = function(){
        	if (_running == true) {
        		//do nothing 
        	} else {
	        	_running = true; 
	            poll();
        	}
        } 

        this.stop = function() {
        	_running = false; 
        }
    } 

    this.create = function( channel ) {
        var socket = new HttpSocket( channel );
        return socket;
    }
} 
