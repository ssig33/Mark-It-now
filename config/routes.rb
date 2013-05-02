MarkItNow::Application.routes.draw do
  root to: 'page#index', as: :index
  match 'search' => 'page#search'
  match 'image' => 'page#image'
  match 'read/:id' => 'page#read', as: :read
  match 'text/:id' => 'page#text', as: :text
  match 'info/:id' => 'page#info'
  match 'aozora/:id' => 'page#aozora', as: :aozora
  match 'save_recent/:id' => 'page#save_recent'
  match 'save_recent_text/:id' => 'page#save_recent_text'
  match 'img_from_name/:id' => 'page#img_from_name'
  match ':controller(/:action(/:id(.:format)))'
end
