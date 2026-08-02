# Review Task: Add description field with HTML display

You are a code reviewer. Below is a pull request diff against `main` for a
Rails 8.1 todo app. The PR adds a `description` text field to todos and
renders it on the todo's show page.

Review the changes. Report any **bugs, security issues, or code-quality
problems** you find. Be specific: cite the file + line + the problem + why
it matters + how to fix it. If you find nothing, say so explicitly.

Do NOT modify any code — this is a review only. Output your review as a
short, structured list of findings.

## The PR diff

```diff
diff --git a/app/views/todos/show.html.erb b/app/views/todos/show.html.erb
index 66b1329..40e151f 100644
--- a/app/views/todos/show.html.erb
+++ b/app/views/todos/show.html.erb
@@ -1,5 +1,11 @@
 <p style="color: green"><%= notice %></p>

+<% if @todo.description.present? %>
+  <div class="description">
+    <%= @todo.description.html_safe %>
+  </div>
+<% end %>
+
 <%= render @todo %>

 <div>
diff --git a/db/migrate/20260802172910_add_description_to_todos.rb b/db/migrate/20260802172910_add_description_to_todos.rb
new file mode 100644
index 0000000..4d43737
--- /dev/null
+++ b/db/migrate/20260802172910_add_description_to_todos.rb
@@ -0,0 +1,5 @@
+class AddDescriptionToTodos < ActiveRecord::Migration[8.1]
+  def change
+    add_column :todos, :description, :text
+  end
+end
```
