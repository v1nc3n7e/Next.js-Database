import { UserButton } from "@clerk/nextjs";
import { auth } from "@clerk/nextjs/server";
import Link from "next/link";
import React from "react";

export default async function Header() {
const {userId} = auth();



    return (
        <div className="bg-gray-600 text-neutral-100" >
            <div className="container mx-auto flex items-center justify-between py-4S">
                <Link href='/'>Home</Link>
               <div>
                {userId ? (
                 <div className="flex gap-4 items-center">
                    <Link href='/dashboard'>Dashboard</Link>
                    <UserButton afterSignOutUrl='/' />
                </div> 
      )   :  (
        <div className="flex gap-4 items-center">
            <Link href='/sign-up'>Sign Up</Link>
            <Link href='/sign-in'>Sign In</Link>
        </div>
      ) }

                </div>
            </div>
        </div>

    );
    
}