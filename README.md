# IRIS HOSTEL MANAGER

<div style="display: flex; gap: 20px;">
    <img src="Images/Screenshot_20241027_180001.png" alt="Screenshot" width="200" style="height:auto;">
    <img src="Images/drawer.png" alt="Drawer" width="200" style="height:auto;">
</div>
<h1>
    Backend
</h1>
The Backend has 6 collections in firestore
<h3>Users</h3>
This collection stores the users email,name,rollNo,uid etc and also their hostel room info.
<h3>room_exchange</h3>
  This collection stores data of the room exchange requests sent by the user.Each Room exchange request will be given an exchange key of the format (x<->y) where x is the smallest room number among both of the students.This ensures that the consent of both parties is confirmed.Their might be another case where 4 ppl from two rooms want to switch rooms so this case is also handled in the flutter code. The room exchange request is displayed to the  admin only if all of the above conditions are true.
<h3>requests</h3>
  This collection stores data of the Hostel change details,Personal Details, The data of current room and the data of the room which the user wants to shift to.Upon approval the hostels collection is updated.
<h3>new_hostels</h3>
  This collection stores information about any new hostels created by the admin.This hostel information is later downloaded locally on the users device on hive.
<h3>leaves</h3>
 This collection stores the information about the leave requests sent by the users and their status.Each of the requests have the student's rollNumbers as the main key to identify the users as this key will be unique.
<h3>hostels</h3>
  This collection stores the realtime occupancy of each hostel. This collection shows how many users are present in each room.This collection is dynamically updated on each operation of the user or the admin




## List of Implimented features

  * Authentication screen integrated with firebase
  * Hostel Dashboard with a drawer
  * Used Hive to store hostel information which also updates when a new hostel is added by the admin
  * Change Hostel feature.(The user can see which rooms are available)
  * My requests module to track your leave requests and hostel change requests
  * Leave Application module to apply for leave
  * Switch Rooms Feature to apply for room switch which requires consent from both the parties
  * Manage Leaves module for admin to approve/reject users leave requests
  * Hostel Requests module for admin to approve/reject users hostel change requests
  * Switch Requests module for admin to approve/reject users room switch requests
  * Hostel Manager module for admin to view all the available hostels,add new ones and  also delete hostels.
  * Student Manager module for admin to view all the students and their details, Also reallocate or deallocate users. This module also has a search feature
  * Use of Bloc for State Management
  * Implemented Role Based Access for admins and users
## List of Planned features 

* Displaying original hostel layouts while hostel booking
* FCM Notifications
## Recordings
<h3>App</h3>
https://drive.google.com/file/d/1OYoBaK6j8lfa8s7Y7qr-0snmoVT8r6Qj/view?usp=drive_link
<h3>Firebase</h3>
https://drive.google.com/file/d/1BJ2OUCJEQeveRu65DYkl2YA9r2DhQhWe/view?usp=sharing
<h3></h3>


## References
* https://www.youtube.com/watch?v=THCkkQ-V1-8
* https://www.youtube.com/watch?v=Y1roIi0-Sro&list=PL9n0l8rSshSkzasAAyVMozHQu8-LdWxI0&index=2
* https://www.youtube.com/watch?v=Dh-cTQJgM-Q&t=127s
  
## Operating system 
windows
## Design Tools
Adobe After Effects
 









