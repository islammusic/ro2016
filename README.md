# Računalniško oblikovanje 2016 - Ruby on Rails

Ne pozabit si razjasnit kaj pomeni MVC!

* **Ustvarimo novo rails aplikacijo**

```
rails new ro2016
```
Ustvarile se vam bodo vse potrebne doatoteke za Rails aplikacijo. Bodite potrpežljivi :)

* **Pomaknete se v novo nastalo aplikacijo in poženete strežnik.**

```
cd ro2016
rails s
```
ker delamo v c9.io strežnik poženemo z ukazom

```
rails s -p $PORT -b $IP
```

* **Ustvarimo novo tabelo za destinacije**

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

* **Naredimo autentifikacijo uporabnika**

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

* **Ko uporabnik doda destinacijo, naj se doda v bazo prijavljeni uporabnik kot lastnik.**

Ustvariti moramo tuji ključ v bazi oz. povezavo med tabelama user in destination.
```
rails g migration AddUserToDestination user:belongs_to
```
Ustavrila se vam bo migracijska skripta:
```
class AddUserToDestination < ActiveRecord::Migration
  def change
    add_reference :destinations, :user, index: true, foreign_key: true
  end
end
```

Poženete migracijo nad bazo:
```
rake db:migrate
```

Sedaj moramo še v kodi urediti povezave oz. odvisnosti. Več o teh stvareh najdete: http://guides.rubyonrails.org/association_basics.html

V datoteki app/models/user.rb na koncu pred "end"
```
has_many :destinations
```

V datoteki /app/models/destination.rb na koncu pred "end"
```
belongs_to :user
```

Tabeli sta sedaj povezani, ker imamo kodo že zgenerirano, moramo še dve stvari spremeniti v controllerju.

V datoteki app/controllers/destinations_controller.rb spremenimo tako, da bo zgledala tako. V spodnji kodi si poglej slovenske komentarje.
```
class DestinationsController < ApplicationController
  before_action :set_destination, only: [:show, :edit, :update, :destroy]

  # GET /destinations
  # GET /destinations.json
  def index
    @destinations = Destination.all
  end

  # GET /destinations/1
  # GET /destinations/1.json
  def show
  end

  # GET /destinations/new
  def new
    @destination = Destination.new
  end

  # GET /destinations/1/edit
  def edit
  end

  # POST /destinations
  # POST /destinations.json
  def create
    #@destination = Destination.new(destination_params)
    
    #zgoraj je orginal
    #da ustvarimo povezavo, bo sedaj user ustvaril destinacijo in se bo zato shranil njegov tuji ključ
    #v spremenljivki current_user je objekt trenutno prijavljenega uporabnika
    @destination = current_user.destinations.build(destination_params)

    respond_to do |format|
      if @destination.save
        format.html { redirect_to @destination, notice: 'Destination was successfully created.' }
        format.json { render :show, status: :created, location: @destination }
      else
        format.html { render :new }
        format.json { render json: @destination.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /destinations/1
  # PATCH/PUT /destinations/1.json
  def update
    #opcijsko, če že imate vnešene kakšne destinacije, preden ste uredili prijavo in povezavo z uporabnikom
    #potem bi ob vsakem urejanju se pod uporabnika vpisal uporabnik, ki trenutno ureja destinacijo
    @destination.user = current_user
    
    respond_to do |format|
      if @destination.update(destination_params)
        format.html { redirect_to @destination, notice: 'Destination was successfully updated.' }
        format.json { render :show, status: :ok, location: @destination }
      else
        format.html { render :edit }
        format.json { render json: @destination.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /destinations/1
  # DELETE /destinations/1.json
  def destroy
    @destination.destroy
    respond_to do |format|
      format.html { redirect_to destinations_url, notice: 'Destination was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_destination
      @destination = Destination.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def destination_params
      params.require(:destination).permit(:name, :description, :picture)
    end
end

```

p.s. Dostop do rails konzole je z ukazom ```rails c```

* **Dodajanje slik destinacije**

Gem spat :), nadaljujem drugič.