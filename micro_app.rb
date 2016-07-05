require 'rubygems'
require 'sinatra'
require 'bson'
require 'json/ext' # required for .to_json
require 'mongoid'
require 'pp'
Mongoid.load!("./mongoid.yml", :development)

module Micro

  class Inventory
    include Mongoid::Document
    include Mongoid::Timestamps
    field :title, type: String
    field :count, type: Integer
    field :product_id, type: Integer
  end


  class MyApp < Sinatra::Base
    use Rack::MethodOverride

    ## Endpoints
    get '/' do
      Inventory.all.to_json
    end
    # create record
    post '/inventory' do
      content_type :json

      inventory = Inventory.new params
      if inventory.save
        inventory.to_json
      end
    end

    # find record
    get '/inventory/:product_id' do
      content_type :json
      inventory = Inventory.where(:product_id => params[:product_id])
      inventory.to_json

    end

    # update record by id 
    put '/inventory/:product_id?' do
      content_type :json
      inventory = Inventory.where(:product_id => params[:product_id]).first
      inventory.update_attributes({title: params[:title], count: params[:count]})
      inventory.to_json
    end

      # delete
      delete '/inventory/:product_id' do
        content_type :json
        inventory = Inventory.where(:product_id => params[:product_id])
        if inventory.delete
          puts "deleted"
        else
          puts "not deleted"
        end
      end

    end
  end
