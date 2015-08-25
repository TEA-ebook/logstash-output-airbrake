logstash-output-airbrake
========================

## Installation de l'environnement de développement

Les plugins logstash sont écrit en ruby mais Logstash nécessite JRuby. La
première étape consiste donc à l'installer :

```bash
rbenv install jruby-9.0.0.0.pre1 # la version peut changer
rbenv global jruby-9.0.0.0.pre1
```

On doit ensuite installer bundler pour cette version de ruby :

```bash
gem install bundler
```

## Tester le plugin sur un serveur logstash local

Dans le répertoire du plugin, installer les dépendances :

```bash
bundle install
```

Puis construire la gem du plugin (si on compte la distribuer, sinon pas besoin) :

```bash
gem build logstash-output-airbrake.gemspec
```

Exécuter le plugin avec une installation de Logstash *depuis les sources* :

- Éditer le `Gemfile` de Logstash pour y ajouter le plugin :
```ruby
gem "logstash-output-airbrake", :path => "/home/kevin/sandbox/logstash-output-airbrake"
```

- Installer le plugin :
```sh
bin/plugin install --no-verify
```

- Exécuter Logstash avec le plugin :
```sh
./bin/logstash --verbose -e 'input { stdin {} } output { airbrake{ api_key => "joe la frite" } }'
```

Les modifications faites au plugin seront partagées avec l'installation faite
dans Logstash, il suffit de le redémarrer pour qu'elles soient prises en compte.
