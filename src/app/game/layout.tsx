import React from "react";

function GameLayout({children}: {children: React.ReactNode}) {
  return (
    <div className="min-h-screen w-full bg-white px-4 py-10 text-zinc-900 sm:px-8 lg:px-12">
      <main className="mx-auto flex w-fit min-w-5xl flex-col gap-6 transition-all duration-300">{children}</main>
    </div>
  );
}

export default GameLayout;
