component displayname="Generator" accessors="TRUE" {


	property any strategy;


	public any function init( any strategy ) {
		setStrategy( structKeyExists( arguments, 'strategy' ) ? arguments.strategy : FALSE );
		return this;
	}



	public void function generate( required string pathToRAML ) {
		// pathToRAML must be an appropriate platform-specific absolute path to the file

		if ( !hasStrategy() ) {
			throw ( 'No generation strategy has been specified' );
		}

		var ramlMetaTree = buildRamlCollection( pathToRAML );
		//writeDump( var="#ramlMetaTree#", expand="FALSE" );

		getStrategy().run( ramlMetaTree );
	}



	public boolean function hasStrategy() {
		return !isBoolean( getStrategy() );
	}



	private struct function buildRamlCollection( required string pathToRAML ) {
		var yamlParser = new Yaml();
		var stringInput = fileRead( pathToRAML );
		return yamlParser.load( stringInput );
	}

}