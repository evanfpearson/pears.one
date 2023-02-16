---
title: "Deploying a Simple Blog"
date: 2023-02-15T22:07:02Z
draft: false
---
# Aims
Build a prototype platform where I can publish articles about things I find interesting. This platform should satisfy some requirements:
- Easy to add posts; otherwise I won't bother writing anything
- Small page sizes; better for page speeds, better for planet
- Customizable; in case I want to get jazzy in the future
- Cheap, if not free; finance

# Tech
- Hugo | Open Source static site generator | free
- Nginx | Web Server | free
- AWS EC2 | Compute | free options
- AWS S3 | Object Storage | free options
- Let's Encrypt | Certificate Authority | free
- Certbot | Certificate Automation | free
- Namecheap | Domain Name Registrar | paid

---

# Hugo
[Official Documentation](https://gohugo.io/documentation/)

Hugo is a static site generator. A static site is a site which will not change in response to user requests. This is good for simple websites such as blogs which change infrequently.

Content in Hugo is written in [Markdown](https://www.markdownguide.org/tools/hugo/). This [syntax](https://www.markdownguide.org/basic-syntax) is far more human friendly than writing HTML making it easy to write with decent flexibility in formatting.

Hugo also allows contributors to create and open source their own themes for others to use. I don't have the patience to deal with CSS any more so this is good for me. I have chosen a lightweight theme, [Etch](https://themes.gohugo.io/themes/etch/).  

After installing Hugo, you will have access to the Hugo [CLI](/glossary#cli). You can then run a few commands to get started.

```shell
hugo new site pears.one # creates directory with hugo structure
cd pears.one # change directory to new directory
hugo new posts/first.md # creates markdown file with some metadata
vim content/posts/first.md # open text editor to write first post
```

After writing your first post, `hugo serve` will build your site and start a small [web server](/glossary#web-server) exposing the site so it is accessible on `localhost`.

You can also use the command `hugo` alone to build the site from your markdown files, i.e., convert them into HTML and CSS so they can be displayed by browsers.

# Serving the Content
[Getting Started with EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html) | [nginx](https://nginx.org/en/docs/beginners_guide.html)

To serve the content I chose to run nginx on AWS EC2. nginx is a [web server](/glossary#web-server), to serve the HTML that I generated with Hugo. EC2 is Amazon's cloud compute offering, it allows you to create virtual servers (instances) in a number of data centers across the world. AWS seemed to offer the best free tier of all the cloud compute platforms and I chose nginx because I am familiar with it.

![Initial Set Up](/nginx.mmd.svg)

Setting up EC2 was simple through the UI, for more information see the Getting Started docs at the top of this section. AWS will provision a virtual server and assign a public IP to it. By default port 22 will be open, allowing us to SSH into the newly created instance. I created a Linux Debian 11 server, this is free for limited compute and memory.

Once we can run commands in the server we can install nginx. I am using `apt` to install the package, other Linux distributions may have different package managers. I am using the `systemctl` command to start the nginx process as a service.

```shell
sudo su # switch to root user
apt update # update list of available packages
apt install nginx
systemctl start nginx
```

Now nginx will be running as a service on the virtual server. You can access the default nginx landing page by entering the IP of your virtual server in your browser.

By default, `nginx` will serve files from the directory `/usr/share/nginx/html`. We can copy the files built by Hugo from our development environment to this directory. Now we should be able to access our blog from the internet by visiting the IP of our EC2 instance.  

Note that it will be necessary to update the security policy on your instance to accept traffic to port 80 for HTTP and port 443 for HTTPS.

# DNS and Certificate Configuration
[Namecheap](https://www.namecheap.com) | [Certbot](https://certbot.eff.org/) | [Let's Encrypt](https://letsencrypt.org/)

First, we need to own a domain name which we can buy from a domain name registrar. I used Namecheap and paid about $2 for 2 years, can't complain about that. Then I navigated to the DNS settings for my domain and created a new [A Record](/glossary#a-record), with Host set to `www` and IP set to the IP of my EC2 instance. Then I could access my blog using `www.pears.one`.

This is good, but all communication is happening over HTTP. This means that visitors to the site will get a warning that the connection to the site is insecure. To get around this it's necessary to get a TLS certificate, and configure the webserver to communicate over HTTPS. [This](https://www.youtube.com/playlist?list=PLSNNzog5eyduzyJ8_6Je-tYOgMHvo344c) is a good series of videos for learning more about TLS.

I found a good tool for automating this process called Certbot. This automates the provisioning of a certificate from Let's Encrypt and will even update your nginx config in place to communicate over HTTPS. Their website has detailed instructions for the set up for varied pairings of web servers and operating systems. For example, I was just able to follow [these steps](https://certbot.eff.org/instructions?ws=nginx&os=debianbuster).

After following these steps I could now access my blog securely using `https://www.pears.one`! 

Prototype ✅

# Next Steps
- Terraform | Cloud Provisioning
- Docker | Package Nginx and Hugo build into container
- Ansible | Server provisioning
- Cert Automation | Automatically renew certs 
- GitHub Actions | CI/CD
