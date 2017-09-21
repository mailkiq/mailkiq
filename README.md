# mailkiq

Mailkiq is an open source email marketing tool that uses Amazon SES under the hood for sending mass emails cheaply. Built upon Ruby on Rails, and PostgreSQL for the queue and data storage.

This side project started in November 2015 when I was working on [Votenaweb](http://votenaweb.com.br). We were using MailChimp for sending hundreds of thousands of newsletters monthly but got very expensive because dollar's value was an absurd in Brazil. 

I've looked for compelling alternatives, but I didn't find one. So I decided to something about it. Mailkiq was born to solve a simple problem: sending lots of emails reliably. 

Obviously, there's still some work left to do. But the foundation is work and running. That means you don't have to go AWS Management Console at all. Just insert your Access Key ID and Secret Access Key, and you're ready to go.

Clone this repository and install the dependencies. Next, create your account in the ruby console. Login into the admin, then change your credentials. Boom! That's all you've to do.

## License

Any use of the Mailkiq trademark is expressly prohibited.

It is free software, and may be redistributed under the terms specified in the MIT License.
