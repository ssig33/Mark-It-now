MarkItNow::Application.routes.draw do
  root to: 'page#index', as: :index
  get 'search' => 'page#search'
  get 'image' => 'page#image'
  get 'read/:id' => 'page#read', as: :read
  get 'text/:id' => 'page#text', as: :text
  get 'info/:id' => 'page#info'
  get 'aozora/:id' => 'page#aozora', as: :aozora
  get 'save_recent/:id' => 'page#save_recent'
  get 'save_recent_text/:id' => 'page#save_recent_text'
  get 'img_from_name/:id' => 'page#img_from_name'
  get 'to/:id' => 'page#from_path', constraints: {id: /.*/}
  get 'memo/:id' => 'page#memo', as: :memo
  post 'memo/:id' => 'page#save_memo'
  match ':controller(/:action(/:id(.:format)))', via: [:post, :get]
end
