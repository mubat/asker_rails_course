require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #new - User can open creation form of Answer' do

    it 'opens under question resource'
    it 'render `new` form'

  end

  describe 'GET #create - User can create new Answer' do
    it 'opens under question resource'

    context 'with valid parameters' do
      it 'saves a new Answer'
      it 'redirects to Question\'s `show` view'
    end

    context 'with invalid parameters' do
      it 'don\'t saves a new invalid Answer'
      it 'reopen the `new` view'
    end
  end
end
