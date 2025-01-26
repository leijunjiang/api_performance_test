require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      task = Task.new(title: 'Test Task', description: 'Test Description')
      expect(task).to be_valid
    end

    it 'is not valid without a title' do
      task = Task.new(description: 'Test Description')
      expect(task).not_to be_valid
    end
  end

  describe 'defaults' do
    it 'sets completed to false by default' do
      task = Task.new(title: 'Test Task')
      expect(task.completed).to be_falsey
    end
  end
end 