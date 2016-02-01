# Računalniško oblikovanje 2016 - Ruby on Rails

Ne pozabit si razjasnit kaj pomeni MVC!

1. Ustvarimo novo rails aplikacijo

```
rails new ro2016
```
Ustvarile se vam bodo vse potrebne doatoteke za Rails aplikacijo. Bodite potrpežljivi :)

2. Pomaknete se v novo nastalo aplikacijo in poženete strežnik.

```
cd ro2016
rails s
```
ker delamo v c9.io strežnik poženemo z ukazom

```
rails s -p $PORT -b $IP
```

3. Ustvarimo novo tabelo za destinacije

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

4. 
5. asdasd
6. asdasdas
7. asdasdasd
8. asdasdas

