require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all tasks' do
      task1 = Task.create(title: 'Task 1', description: 'Description 1')
      task2 = Task.create(title: 'Task 2', description: 'Description 2')
      
      get :index
      
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(2)
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { task: { title: 'New Task', description: 'New Description' } } }
    let(:invalid_params) { { task: { description: 'New Description' } } }

    it 'creates a new task with valid params' do
      expect {
        post :create, params: valid_params
      }.to change(Task, :count).by(1)
      
      expect(response).to have_http_status(:created)
    end

    it 'fails to create task with invalid params' do
      expect {
        post :create, params: invalid_params
      }.not_to change(Task, :count)
      
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT #update' do
    let!(:task) { Task.create(title: 'Original Title', description: 'Original Description') }
    
    it 'updates the task' do
      put :update, params: { 
        id: task.id, 
        task: { title: 'Updated Title' } 
      }
      
      task.reload
      expect(task.title).to eq('Updated Title')
      expect(response).to be_successful
    end
  end

  describe 'DELETE #destroy' do
    let!(:task) { Task.create(title: 'Test Task') }
    
    it 'deletes the task' do
      expect {
        delete :destroy, params: { id: task.id }
      }.to change(Task, :count).by(-1)
      
      expect(response).to have_http_status(:no_content)
    end
  end
end 