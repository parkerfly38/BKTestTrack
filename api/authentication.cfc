component persistent="false" accessors="true" output="false" {
  
  	property name="fw" type="any";
  	objData = createObject("component", "/CFTestTrack/cfc/Data");
  	
  	public any function authenticateRequest(required string verb,required string cfc,
  	required struct requestArguments,required struct requestHeaders) {
  	
  		if(!checkRequiredArguments(arguments.requestHeaders)) {
  			return "Authentication Required: Missing request arguments.";
  		}
  	
  		if(!havePrivateKey(arguments.requestHeaders.publicKey)) {
  			return "Authentication Required: No API user by the key.";
  		}
  		
  		if(!isKeyActivated(arguments.requestHeaders.publicKey)) {
  			return "Authentication Required: API Key not activated.";
  		}
  	  
  		if(!timeInAcceptableBounds(arguments.requestHeaders.timestamp)) {
  			return "Authentication: Request timeout";
  		}
  	
  		if(!compareSignature(theirSign=arguments.requestHeaders.signature,
  		    areSign=EncryptSignature(argValue=createSignString(arguments.requestHeaders),
  		    publicKey=arguments.requestHeaders.publicKey))) {
  			return "Authentication required: signature is not recognized.";
  		}
  		
  		return true;
  	}
  	
  	public any function timeInAcceptableBounds(required any timestamp) 
  	hint="I check the request was send within acceptable bounds." {
  		local.dif=DateDiff("m",arguments.timestamp,now());
  		if(local.dif gt 5) {
  			return false;
  		} else {
  		
  			return true;
  		}
  	}
  	
  	public any function compareSignature(required any theirSign,required any areSign) 
  	hint="I compare the two signatures." {
  		if(trim(arguments.theirSign) eq trim(arguments.areSign)) {
  			return true;
  		} else {
  			return false;
  		}
  	}
  	
  	public any function EncryptSignature(required string argValue,required string publicKey) 
  	hint="I create my own signature that I will match with the clients" {
  		var jMsg=JavaCast("string",arguments.argValue).getBytes("iso-8859-1");
  		var jKey=JavaCast("string",objData.getPrivateKeyByPublicKey(arguments.publicKey)).getBytes("iso-8859-1");
  		var key=createObject("java","javax.crypto.spec.SecretKeySpec");
  		var mac=createObject("java","javax.crypto.Mac");
  		key=key.init(jKey,"HmacSHA1");
  		mac=mac.getInstance(key.getAlgorithm());
  		mac.init(key);
  		mac.update(jMsg);
  		return lCase(binaryEncode(mac.doFinal(),'Hex'));
  	}
  	
  	public string function createSignString(required struct requestArguments) 
  	hint="I create the string for my signature." {
  		var local.returnString = arguments.requestArguments.timestamp & arguments.requestArguments.publicKey;		
  		return local.returnString;
  	}
  	
  	public any function havePrivateKey(required string publicKey) 
  	hint="I check API User exisits and has a key." {
  		if (Len(objData.getPrivateKeyByPublicKey(arguments.publicKey)) gt 0)
  		{
  			return true;
  		} else {
  			return false;
  		}
  	}
  	
  	public boolean function isKeyActivated(required string publicKey)
  	{
  		return objData.isAPIKeyActivated(arguments.publicKey);
  	}
  	
  	public any function checkRequiredArguments(required requestArguments) 
  	hint="I check we have the required arguments to authenticate this request." {
  		if(structkeyexists(arguments.requestArguments,"publicKey") 
  		AND structkeyexists(arguments.requestArguments,"signature") 
  		AND structkeyexists(arguments.requestArguments,"timestamp")) {
  			return true;
  		}
  		return false;
  	}   	
}