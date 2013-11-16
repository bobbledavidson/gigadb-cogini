<?php

return array(
    'params'=>array(
        'home_url' => 'http://gigadb.org', // Where top level link goes to

        // Used in the contact page
        'adminEmail' => 'database@gigasciencejournal.com',

        // This is used as the sender of emails
        'app_email_name' => 'Giga DB',
        'app_email' => 'database@gigasciencejournal.com',
        'email_prefix' => '[Giga DB] ', // put at the begining of the subject line

        'support_email' => 'database@gigasciencejournal.com',

        // Notified when a new user signs up
        'notify_email' => 'database@gigasciencejournal.com',

        // Cogini
        'recaptcha_publickey' => '6LdkzgsAAAAAAGFJ5GdJyXf4JvFqKJe5N0-F3IRt',
        'recaptcha_privatekey' => '6LdkzgsAAAAAAD6w-JyWXLfN1260aeRNl33I-JH9',
        "google_analytics_profile" => "UA-40438882-1",

        // Sphinx params
        'sphinx_servername' => '127.0.0.1',
        'sphinx_port' => 9312,

        // MC api
        'mc_apikey' => 'a6f0c4189a9407a2758ad9f53f22dc67-us5',
        'mc_listID' => '4be098275c',
    ),
);
