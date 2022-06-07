using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Todorin.Models;
using Task = Todorin.Models.Task;

namespace Todorin.Services
{
    public static class ApiTasks
    {
        public static async Task<ObservableCollection<Task>> GetTasksAsync(string jwtToken)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
                "Bearer", jwtToken);

            var json = await client.GetStringAsync(Constants.TasksUrl);

            var tasks = JsonConvert.DeserializeObject<List<Task>>(json);
            if (tasks == null) return null;
            var observableCollection = new ObservableCollection<Task>(tasks);
            return observableCollection;
        }

        public static async Task<HttpResponseMessage> PutTaskAsync(Task task, string jwtToken)
        {
            var pureTask = task.PurifyTask();
            var client = new HttpClient();
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
                "Bearer", jwtToken);
            var json = JsonConvert.SerializeObject(pureTask);
            HttpContent content = new StringContent(json);
            content.Headers.ContentType = new MediaTypeHeaderValue("application/json");

            var response = await client.PutAsync(Constants.TasksUrl + task.Id, content);
            return response;
        }

        public static async Task<HttpResponseMessage> DeleteTaskAsync(string id, string jwtToken)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
                "Bearer", jwtToken);

            var response = await client.DeleteAsync(Constants.TasksUrl + id);
            return response;
        }

        public static async Task<HttpResponseMessage> PostTaskAsync(Task task, string jwtToken)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
                "Bearer", jwtToken);
            var json = "{"
                       + "\"taskName\": \"" + task.TaskName
                       + "\", \"taskSort\": 0"
                       + ", \"isCompleted\": false"
                       + ", \"isArchived\": false"
                       + ", \"todoCategoryId\": \"" + task.TodoCategoryId
                       + "\", \"todoPriorityId\": \"" + task.TodoPriorityId
                       + "\"}";
            HttpContent content = new StringContent(json);
            content.Headers.ContentType = new MediaTypeHeaderValue("application/json");

            var response = await client.PostAsync(Constants.TasksUrl, content);
            return response;
        }
    }
}