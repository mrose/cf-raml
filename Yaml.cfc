component
	accessors="TRUE"
	hint="YAML 1.1 parser and emitter, wrapping SnakeYaml 1.13" {

	// see: http://code.google.com/p/snakeyaml/

	// warning: depending on your setup, potential memory management issues may occur using the internally provided javaloader
	// see: https://github.com/markmandel/JavaLoader

	property type="any" name="javaloader" hint="optional. a javaloader or the path to one";
	property type="array" name="loadPaths" hint="optional. an array of class/jar paths for the javaloader";

	variables.yaml = FALSE; // the wrapped Yaml java instance


	public any function init( any javaloader, array loadPaths ) {
		setLoadPaths( structKeyExists( arguments, 'loadPaths' ) ? arguments.loadPaths : [ expandPath( 'lib/snakeyaml/snakeyaml-1.13.jar' ) ] );
		setJavaloader( structKeyExists( arguments, 'javaloader' ) ? arguments.javaloader : FALSE );

		// if no javaloader was provided, we'll use one interally, found in this distribution
		if ( isBoolean( getJavaloader() ) ) {
			setJavaloader( 'lib.javaloader_v1_1.javaloader.JavaLoader' );
		}

		// if a path to a javaloader exists, we'll create it from the string
		if ( isValid( 'String', getJavaloader() ) ) {
			setJavaloader( createObject( 'component', getJavaloader() ).init( loadPaths=getLoadPaths() ) );
		}

		variables.yaml = getJavaloader().create( 'org.yaml.snakeyaml.Yaml' ).init();

		return this;
	}



	// Warning: It is not safe to call Yaml.loadFromFile() with any data received from an untrusted source!
	public any function loadFromFile( required string path ) {
		var flenam = arguments.path; // silly joke to myself
		var v = "";

		// if maybe it's a logical path, expand it
		if ( !fileExists( flenam ) ) {
			flenam = expandPath( flenam );
		}

		if ( fileExists( flenam ) ) {
			v = fileRead( flenam );
			return load( v );
		}

		// uh-oh. no file so throw
		throw( type='InvalidArgumentException' message='Invalid path argument: file does not exist (#arguments.path#)' );
	}



	// Warning: It is not safe to call Yaml.load() with any data received from an untrusted source!
	public any function load( required any input ) {
		return variables.yaml.load( arguments.input );
	}



	public string function dump( required any input ) {
		return variables.yaml.dump( arguments.input );
	}

}