Started writing <a href="http://www.curriculumvitae.co.za/" target="_blank">Curriculum Vitae</a> over. Going to be open sourcing everything.

Learned a lot from the first time but after watching traffic and seeing reactions to the site I made a&nbsp;informed&nbsp;decision.

Analytics show that I will need to implement a "com on and create your CV, oh want to save all that? Then login and save it".

I'm trying to shy away from having all actions only&nbsp;accessible&nbsp;after logging in. Going to try to expose as much of the service as I can before a user has to login.

Along with this options to customize the the CV generation according to your tastes and how you want it's layout.&nbsp;

I'm going to this by&nbsp;separating&nbsp;all parts of the infrastructure. It's a lot of work but will be a interesting journey.

First ?&nbsp;

<p><b>The Service Generation Service.&nbsp;</b></p>

This weekend I'll be starting development on a new Service that will allow me and anyone else to simply call a API and have it return me a CV. The service will not store any data. Only Input and Output. Every Service built after this will be built using the same idea. This allows me to scale certain components as the need arises. For example. Say that 80% of users are generating CV's but only 10% are logging and saving their information. So no need to scale out the site but I will be able to scale the CV Building Server. Get Where I'm going with this?

Created a Organization on Github to organize my efforts and started on the CV Build Service.&nbsp;

View the organization at :

<p><a href="https://github.com/CurriculumVitae">https://github.com/CurriculumVitae</a></p>

and the Project at:

<p><a href="https://github.com/CurriculumVitae/CV-Builder">https://github.com/CurriculumVitae/CV-Builder</a></p>