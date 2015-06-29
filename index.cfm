<h1>RAML taffy generator</h1>
<cfparam name="url.run" default="FALSE" >
<cfif ( url.run ) >
  <cfscript>
    // path to generated files
    genpath = expandpath( './generated' );
    // template to use
    gentemplate =  expandpath( './strategy/Template.cfc' );
    strategy = new strategy.TaffyStrategy( genpath, gentemplate );
    generator = new Generator( strategy );
    generator.generate( expandPath( 'test/test.raml' ) );
  </cfscript>
  <h1>Done!</h1>
  <p>Check the 'generated' directory</p>
<cfelse>
  <p><a href="index.cfm/run=TRUE">Click to run</a></p>
</cfif>