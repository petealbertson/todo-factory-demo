# Review Task: Search todos by title

You are a code reviewer. Below is a pull request diff against `main` for a
Rails 8.1 todo app. The PR adds the ability to search todos by title.

Review the changes. Report any **bugs, security issues, or code-quality
problems** you find. Be specific: cite the file + line + the problem + why
it matters + how to fix it. If you find nothing, say so explicitly.

Do NOT modify any code — this is a review only. Output your review as a
short, structured list of findings.

## The PR diff

```diff
diff --git a/app/controllers/todos_controller.rb b/app/controllers/todos_controller.rb
index eeaf4ab..30fc93b 100644
--- a/app/controllers/todos_controller.rb
+++ b/app/controllers/todos_controller.rb
@@ -3,7 +3,11 @@ class TodosController < ApplicationController

   # GET /todos or /todos.json
   def index
-    @todos = Todo.ordered
+    if params[:q].present?
+      @todos = Todo.where("title LIKE '%#{params[:q]}%'").ordered
+    else
+      @todos = Todo.ordered
+    end
   end

   # GET /todos/1 or /todos/1.json
diff --git a/app/views/todos/index.html.erb b/app/views/todos/index.html.erb
index 61f0f42..f6ff2b3 100644
--- a/app/views/todos/index.html.erb
+++ b/app/views/todos/index.html.erb
@@ -6,6 +6,11 @@

 <h1>Todos</h1>

+<%= form_with url: todos_path, method: :get, local: true do |f| %>
+  <%= f.text_field :q, value: params[:q], placeholder: "Search todos by title..." %>
+  <%= f.submit "Search" %>
+<% end %>
+
 <p>Completed: <%= todos.count(&:completed?) %> of <%= todos.size %></p>
```
