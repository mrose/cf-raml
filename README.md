# cf-raml

2012 / CF9 : Generate  resources using a customizable CFC template and the java RAML parser.

Thanks to:

Adam Tuttle for [Taffy](https://github.com/atuttle/Taffy)

Mark Mandel for [Javaloader](https://github.com/markmandel/JavaLoader)

Andrey Somov for [SnakeYaml](https://bitbucket.org/asomov/snakeyaml)

no working mxunit tests;

WARNING: depending on your setup, potential memory management issues may occur using the internally provided javaloader

WARNING: It is not safe to call Yaml.load() or Yaml.loadFromFile() with data received from an untrusted source!
