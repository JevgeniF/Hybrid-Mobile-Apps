using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Todorin.Models;

namespace Todorin.Services
{
    public static class ApiAuthentication
    {
        public static async Task<HttpResponseMessage> SignUpAsync(string firstName, string lastName, string email,
            string password)
        {
            var client = new HttpClient();

            var user = new User
            {
                FirstName = firstName,
                LastName = lastName,
                Email = email,
                Password = password
            };

            var json = JsonConvert.SerializeObject(user);
            HttpContent content = new StringContent(json);
            content.Headers.ContentType = new MediaTypeHeaderValue("application/json");
            var response = await client.PostAsync(Constants.RegisterUrl, content);
            return response;
        }

        public static async Task<HttpResponseMessage> SignInAsync(string email, string password)
        {
            var client = new HttpClient();

            var user = new User
            {
                Email = email,
                Password = password
            };

            var json = JsonConvert.SerializeObject(user);
            HttpContent content = new StringContent(json);
            content.Headers.ContentType = new MediaTypeHeaderValue("application/json");
            var response = await client.PostAsync(Constants.LoginUrl, content);
            return response;
        }
    }
}