component displayname="TaffyStrategy" accessors="TRUE" {


	property string folder;
	property string template;
	property array verbs;


	public any function init( required string folder, required string template ) {
		setFolder( arguments.folder );
		setTemplate( arguments.template );
		setVerbs( ['get','post','put','delete'] );

		if ( !directoryExists( arguments.folder ) ) {
			directoryCreate( arguments.folder );
		}

		return this;
	}


	public void function run( required any ramlMetaTree ) {
		var i = 0;
		var a = [ ];

		a = listToArray( structKeyList( ramlMetaTree ) );

		for ( i in a ) {
			if ( left( i, 1 ) == '/' ) {
				write( i, ramlMetaTree[i] );
			}
		}
	}


	public void function write( required string route, required struct ramlMetaTree ) {
		var i = 0;
		var a = listToArray( structKeyList( ramlMetaTree ) );
		var f = createFilestring( a, route, ramlMetaTree );

		writeFilestring( route, f );

trace ( text='route is #route#' );
		for ( i in a ) {

			if ( arrayFindNoCase( getVerbs(), i ) ) {
				// it's get, post, put, or delete - dont' do that
				continue;
			}

			// now kids, so recurse unless an end node
			if ( isStruct( ramlMetaTree[i] ) ) {
				write( route & i, ramlMetaTree[i] );
			}

		}
	}

	private string function createFilestring( required array nodes, required string route, any ramlMetaTree ) {
		var i = 0;
		var crlf = chr(13) & chr(10);
		var tab = chr(9);
		var t = { };
		var filestring = rereplace( fileRead( getTemplate() ), '\{taffy_uri}', arguments.route, 'ALL' );
		filestring = left( filestring, len( filestring )-1 ); // last char of filestring s/b closing paren

		for ( i in nodes ) {

			// it's get, post, put, or delete
			if ( arrayFindNoCase( getVerbs(), i ) ) {

				try {
					t = ramlMetaTree[i];
				} catch ( any e  ) {
					// ignore ( null empty node ). can't avoid. ugh.
					t = { };
				}

				filestring = filestring & createVerbFunction( i, t );
			}
		}

			filestring = filestring & '#crlf#}';
			return filestring;
	}


	private void function writeFileString( required string route, required string filestring ) {
		var flenam = route == '/' ? 'index': right( route, len( route )-1 );
		var folder = right( getFolder(), 1 ) != '/' ? getFolder() & '/' : getFolder(); // add trailing slash if nesc
		var filepath = folder & replace( flenam, '/', '_', 'ALL' ) & '.cfc';

		filepath = rereplace( filepath, '[\{}]', '', 'ALL' ); // remove parens

		if ( fileExists( filepath ) ) {
			fileDelete( filepath );
		}

		filewrite( filepath, filestring );
	}


	private string function createVerbFunction( required any verb, required any tree ) {
		var crlf = chr(13) & chr(10);
		var tab = chr(9);
		var f = "";

		f = crlf & tab & 'function ' & verb & '(';

		if ( !structIsEmpty( tree ) && structKeyExists( tree, 'queryParameters' ) ) {
			f = f & createFunctionArguments( tree['queryParameters'] );
		}


		f = f & ') {' & crlf ;

		if ( !structIsEmpty( tree ) && structKeyExists( tree, 'queryParameters' ) ) {
			f = f & createRequiredArgumentExceptions( tree['queryParameters'] );
		}

		f = f & crlf & tab & '}' & crlf & crlf;
		return f;
	}


	private string function createFunctionArguments( required struct tree ) {
		var str = "";
		var ss = "";
		var i = "";

		for ( i in tree ) {
			ss = len( str ) ? ', ' : ' ';

			if ( isStruct( tree[i] ) ) {
				if ( structKeyExists( tree[i], 'type' ) ) {
					ss = ss & tree[i]['type'] & ' ';
				}
			}

			str = str & ss & i;
		}

		str = str & ' ';
		return str;
	}


	private string function createRequiredArgumentExceptions( required struct tree ) {
		var crlf = chr(13) & chr(10);
		var tab = chr(9);
		var str = "";
		var ss = "";
		var i = "";

		for ( i in tree ) {
			ss = "";
			if ( isStruct( tree[i] ) && structKeyExists( tree[i], 'required' ) and tree[i]['required'] ) {
				ss = ss & crlf & tab & tab & 'if ( !structKeyExists( arguments, #i# ) ) {';
				ss = ss & crlf & tab & tab & tab & 'throw( type="missingArgumentException", text="#i# is required" );';
				ss = ss & crlf & tab & tab & '}';
				ss = ss & crlf;
			}
			str = str & ss;
		}

		return str;
	}

}