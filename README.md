# Računalniško oblikovanje 2016 - Ruby on Rails

Ne pozabit si razjasnit kaj pomeni MVC!

* Ustvarimo novo rails aplikacijo

```
rails new ro2016
```
Ustvarile se vam bodo vse potrebne doatoteke za Rails aplikacijo. Bodite potrpežljivi :)

* Pomaknete se v novo nastalo aplikacijo in poženete strežnik.

```
cd ro2016
rails s
```
ker delamo v c9.io strežnik poženemo z ukazom

```
rails s -p $PORT -b $IP
```

* Ustvarimo novo tabelo za destinacije

```
rails generate scaffold destination name:string description:text picture:string
```
Pazite na uporabo edine oz. množine. Scaffold nam bo ustvari ustrezni model (povezava s tabelo v bazi), view in seveda controler. Polja v so lahko poljubna. Samodejno nam ustvari id in datumska polja (kdaj ste ustvarili in nazadnje posodobili zapis).

V bazi še ni ustvaril tabele, pripravljena je le skripta. Poženemo migracijo, ki bo ustvarila tabelo v bazi.
```
rake db:migrate
```
Novo ustvarjeno lahko preverite tako, da poženete strežnik in gresta na ...\destinations

Če želite urediti "obvezna" polja, dolžine ... Nekaj primerov (ne za konkretni primer):
```
validates :name, presence: true
validates :name, length: { minimum: 2 }
validates :bio, length: { maximum: 500 }
validates :password, length: { in: 6..20 }
validates :registration_number, length: { is: 6 }
validates :content, length: {
    minimum: 300,
    maximum: 400,
    tokenizer: lambda { |str| str.split(/\s+/) },
    too_short: "must have at least %{count} words",
    too_long: "must have at most %{count} words"
  }
validates :points, numericality: true
validates :games_played, numericality: { only_integer: true }
```
Več najdeš na: http://guides.rubyonrails.org/active_record_validations.html

* Naredimo autentifikacijo uporabnika

V Gemfile dodamo polje za gem devise, ki služi za avtentifikacijo. Obstajajo še več drugih gem za to nalogo. Več o tem gem: https://github.com/plataformatec/devise

```
# add gem for authentication
gem 'devise'
```
Ne pozabit shranit Gemfile. Poženemo v terminalu ukaz, da se nam v okolje namesti devise
```
bundle install 
```
Nato nametimo devise v okolje, da v terminalu poženemo ukaz.
```
rails generate devise:install
```
Ustvarimo uporabnika z devise (naredil bo osnovno verzijo uporabnika).
```
rails generate devise user
```
Ker nam je ustvaril tudi tabelo user, moramo akcije izvršiti tudi nad bazo.
```
rake db:migrate
```

Gremo v app/controllers/application_controller.rb in dodamo vrstico ```before_filter :authenticate_user!```, da se autetikacija izvede vedno. Po dodani vrstici bo izgledala datoteka:

```
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!
end
```

Prej smo pozabili še nastaviti, da naj bo naša začetna stran "/destinations". To uredimo tako, da v config/routes.rb poiščemo in odkomentiramo ```#root 'welcome#index'```, ter spremenimo v ```root 'destinations#index'```. 

Preverite tako, da poženete strežnik in obiščite vašo aplikacijo. Brez prijave ne boste mogli dostopati do nje.