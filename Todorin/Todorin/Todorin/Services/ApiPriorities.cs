using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Todorin.Models;

namespace Todorin.Services
{
    public static class ApiPriorities
    {
        public static async Task<List<Priority>> GetPrioritiesAsync(string jwtToken)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
                "Bearer", jwtToken);

            var json = await client.GetStringAsync(Constants.PrioritiesUrl);

            var priorities = JsonConvert.DeserializeObject<List<Priority>>(json);
            return priorities;
        }

        public static async Task<HttpResponseMessage> PostPriorityAsync(Priority priority, string jwtToken)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
                "Bearer", jwtToken);
            var json = "{\"priorityName\": \"" + priority.PriorityName
                       + "\", \"prioritySort\": " + priority.PrioritySort + "}";
            HttpContent content = new StringContent(json);
            content.Headers.ContentType = new MediaTypeHeaderValue("application/json");

            var response = await client.PostAsync(Constants.PrioritiesUrl, content);
            return response;
        }
    }
}